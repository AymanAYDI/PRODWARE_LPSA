report 50045 "PWD TPL Suppression Gamme"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.20
    // P24578_007 : RO 11/09/2019 : New report
    // 
    // ------------------------------------------------------------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/TPLSuppressionGamme.rdl';
    UsageCategory = None;

    dataset
    {
        dataitem(RoutingHeaderTemp; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(RecGRoutingHeaderTemp__No__; RecGRoutingHeaderTemp."No.")
            {
            }
            column(RecGRoutingHeaderTemp_Description; RecGRoutingHeaderTemp.Description)
            {
            }
            column(RecGRoutingHeaderTemp__Description_2_; RecGRoutingHeaderTemp."Description 2")
            {
            }
            column(RoutingHeaderTemp_Number; Number)
            {
            }
            column(Gamme_N_Caption; Gamme_N_CaptionLbl)
            {
            }
            column("Article_liéCaption"; Article_liéCaptionLbl)
            {
            }
            column("OF_liéCaption"; OF_liéCaptionLbl)
            {
            }
            column(RoutingHeaderTemp_NumberCaption; FieldCaption(Number))
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    RecGRoutingHeaderTemp.Find('-')
                else
                    RecGRoutingHeaderTemp.Next();
            end;

            trigger OnPreDataItem()
            begin
                if RecGRoutingHeaderTemp.Count = 0 then
                    CurrReport.Break();

                SetRange(Number, 1, RecGRoutingHeaderTemp.Count);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1000000000)
                {
                    Caption = 'Action';
                    ShowCaption = false;
                    field(TxtGFileF; TxtGFile)
                    {
                        Caption = 'Fichier à importe';
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                    field(BooGDelRoutingNoOnItemF; BooGDelRoutingNoOnItem)
                    {
                        Caption = 'Supprimer le N° gamme sur la fiche article lié';
                        ApplicationArea = All;
                        ShowCaption = false;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                        // CduGCommonDialogMgt: CodeUnit "Common Dialog Management";
                        begin
                            // TxtGFile := CduLCommonDialogMgt.OpenFile('Fichier à importer', TxtGFile, 1, 'Filter', 0); //TODO: Codeunit n'existe pas(code standard dans la version 2009)
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Message('traitement terminé');
    end;

    trigger OnPreReport()
    var
        RecLItem: Record Item;
    begin
        FilGFileToImport.TextMode(false);
        FilGFileToImport.Open(TxtGFile);
        FilGFileToImport.CreateInStream(InsGDataFileInstream);

        while not (InsGDataFileInstream.EOS) do begin
            InsGDataFileInstream.ReadText(TxtGReadLine);
            if RecGRoutingHeader.Get(TxtGReadLine) then begin
                RecGItem.Reset();
                RecGItem.SetCurrentKey("Routing No.");
                RecGItem.SetRange("Routing No.", RecGRoutingHeader."No.");
                if RecGItem.FindFirst() then
                    BooGItemFind := true
                else
                    BooGItemFind := false;

                RecGProdOrderRoutingLine.Reset();
                RecGProdOrderRoutingLine.SetCurrentKey("Routing No.");
                RecGProdOrderRoutingLine.SetRange("Routing No.", RecGRoutingHeader."No.");
                RecGProdOrderRoutingLine.SetFilter(Status, '<%1', RecGProdOrderRoutingLine.Status::Finished);
                if RecGProdOrderRoutingLine.FindFirst() then
                    BooGOFFind := true
                else
                    BooGOFFind := false;

                if BooGItemFind or BooGOFFind then begin
                    RecGRoutingHeaderTemp.Init();
                    RecGRoutingHeaderTemp."No." := RecGRoutingHeader."No.";
                    RecGRoutingHeaderTemp.Insert();
                    RecGRoutingHeaderTemp.Description := '';
                    RecGRoutingHeaderTemp."Description 2" := '';
                    if BooGItemFind then
                        RecGRoutingHeaderTemp.Description := RecGItem."No.";
                    if BooGOFFind then
                        RecGRoutingHeaderTemp."Description 2" := RecGProdOrderRoutingLine."Prod. Order No.";
                    RecGRoutingHeaderTemp.Modify();
                end else begin
                    if (RecGRoutingHeader.Status = RecGRoutingHeader.Status::Certified) then begin
                        RecGRoutingHeader.Validate(Status, RecGRoutingHeader.Status::"Under Development");
                        RecGRoutingHeader.Modify(true);
                    end;
                    RecGRoutingHeader.Delete(true);
                end;
            end;
        end;

        // cas où on vide le N° gamme sur la fiche article.
        if BooGDelRoutingNoOnItem then begin
            //On commence par vider N° gamme sur la fiche article.
            RecGRoutingHeaderTemp.Reset();
            if RecGRoutingHeaderTemp.FindFirst() then
                repeat
                    RecGItem.Reset();
                    RecGItem.SetCurrentKey("Routing No.");
                    RecGItem.SetRange("Routing No.", RecGRoutingHeaderTemp."No.");
                    if RecGItem.FindFirst() then
                        repeat
                            RecLItem.Get(RecGItem."No.");
                            RecLItem.Validate("Routing No.", '');
                            RecLItem.Modify(true);
                        until RecGItem.Next() = 0;
                until RecGRoutingHeaderTemp.Next() = 0;

            Commit();

            // on supprime la gamme

            RecGRoutingHeaderTemp.Reset();
            if RecGRoutingHeaderTemp.FindFirst() then
                repeat
                    if (RecGRoutingHeaderTemp."Description 2" = '') then begin
                        RecGRoutingHeader.Get(RecGRoutingHeaderTemp."No.");
                        if (RecGRoutingHeader.Status = RecGRoutingHeader.Status::Certified) then begin
                            RecGRoutingHeader.Validate(Status, RecGRoutingHeader.Status::"Under Development");
                            RecGRoutingHeader.Modify(true);
                        end;
                        RecGMfgComment.SetRange("Table Name", RecGMfgComment."Table Name"::"Routing Header");
                        RecGMfgComment.SetRange("No.", RecGRoutingHeader."No.");
                        RecGMfgComment.DeleteAll();

                        RecGRtngLine.LockTable();
                        RecGRtngLine.SetRange("Routing No.", RecGRoutingHeader."No.");
                        RecGRtngLine.DeleteAll(true);

                        RecGRtngVersion.SetRange("Routing No.", RecGRoutingHeader."No.");
                        RecGRtngVersion.DeleteAll();

                        RecGRoutingHeader.Delete();

                    end;
                until RecGRoutingHeaderTemp.Next() = 0;
        end;
    end;

    var
        RecGItem: Record Item;
        RecGMfgComment: Record "Manufacturing Comment Line";
        RecGProdOrderRoutingLine: Record "Prod. Order Routing Line";
        RecGRoutingHeader: Record "Routing Header";
        RecGRoutingHeaderTemp: Record "Routing Header" temporary;
        RecGRtngLine: Record "Routing Line";
        RecGRtngVersion: Record "Routing Version";
        BooGDelRoutingNoOnItem: Boolean;
        BooGItemFind: Boolean;
        BooGOFFind: Boolean;
        FilGFileToImport: File;
        InsGDataFileInstream: InStream;
        "Article_liéCaptionLbl": Label 'Article lié';
        Gamme_N_CaptionLbl: Label 'Gamme N°';
        "OF_liéCaptionLbl": Label 'OF lié';
        TxtGReadLine: Text[30];
        TxtGFile: Text[255];
}

