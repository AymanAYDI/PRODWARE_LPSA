report 50019 "PWD Compl. fiche suiveuse"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 24/10/2017 : FICHE SUIVEUSE - PP 1
    //                   - Add "Source Material Vendor" in section/Layout
    //                   - Add BarCode for OF in Layout
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/Complfichesuiveuse.rdl';


    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = WHERE(Status = CONST(Released));
            RequestFilterFields = Status, "No.", "Location Code";
            column(Production_Order__Production_Order___No__; "Production Order"."No.")
            {
            }
            column(RecLItemSO__No__; ConcatComponentNo)
            {
            }
            column(RecLItemPF__No__; RecLItemPF."No.")
            {
            }
            column(FORMAT_RecLProdOC__Expected_Quantity__; Format(SumComponentQty))
            {
            }
            column(RecLItemPF__LPSA_Description_1_; RecLItemPF."PWD LPSA Description 1")
            {
            }
            column(RecLItemSO__LPSA_Description_1_; RecLItemSO."PWD LPSA Description 1")
            {
            }
            column(RecLItemPF__LPSA_Description_2_; RecLItemPF."PWD LPSA Description 2")
            {
            }
            column(RecLItemSO__LPSA_Description_2_; RecLItemSO."PWD LPSA Description 2")
            {
            }
            column(RecLItemPF__SearchDescription__; RecLItemPF."Search Description")
            {
            }
            column(FORMAT_RecLProdOC__Final_Quantity__; Format(RecLProdOL.Quantity))
            {
            }
            column(FORMAT_CodLLotNo_component; CodLLotNo_component)
            {
            }
            column(Lot1; Lot1)
            {
            }
            column(Lot2; Lot2)
            {
            }
            column(Lot3; Lot3)
            {
            }
            column(RecLItemPF__Type; Format(RecLConfPF."Product Type"))
            {
            }
            column(Production_Order__Source_Material_Vendor_; "PWD Source Material Vendor")
            {
            }
            column(Lot4; Lot4)
            {
            }
            column("FICHE_SUIVEUSE__complément_technique_Caption"; FICHE_SUIVEUSE__complément_technique_CaptionLbl)
            {
            }
            column(RecLItemSO__No__Caption; RecLItemSO__No__CaptionLbl)
            {
            }
            column(RecLItemPF__No__Caption; RecLItemPF__No__CaptionLbl)
            {
            }
            column(RecLItemPF__LPSA_Description_1_Caption; RecLItemPF__LPSA_Description_1_CaptionLbl)
            {
            }
            column(RecLItemSO__LPSA_Description_1_Caption; RecLItemSO__LPSA_Description_1_CaptionLbl)
            {
            }
            column(RecLItemPF__LPSA_Description_2_Caption; RecLItemPF__LPSA_Description_2_CaptionLbl)
            {
            }
            column(RecLItemSO__LPSA_Description_2_Caption; RecLItemSO__LPSA_Description_2_CaptionLbl)
            {
            }
            column(Mesure_Caption; Mesure_CaptionLbl)
            {
            }
            column(SO_Caption; SO_CaptionLbl)
            {
            }
            column(FORMAT_CodLLotNo_component_Caption; FORMAT_CodLLotNo_component_CaptionLbl)
            {
            }
            column(LotCaption; LotCaptionLbl)
            {
            }
            column(Quantite_Caption; Quantite_CaptionLbl)
            {
            }
            column(Production_Order__Source_Material_Vendor_Caption; FieldCaption("PWD Source Material Vendor"))
            {
            }
            column(Production_Order_Status; Status)
            {
            }

            trigger OnAfterGetRecord()
            var
                RecLItemLedgerEntry: Record "Item Ledger Entry";
                RecLReservation: Record "Reservation Entry";
            begin
                Clear(RecLItemPF);
                Clear(RecLConfPF);
                Clear(RecLItemSO);
                Clear(RecLConfSO);
                Clear(RecLProdOC);
                Clear(RecLProdOL);

                //Determine l'article PF
                RecLProdOL.SetRange(Status, Status);
                RecLProdOL.SetRange("Prod. Order No.", "No.");
                if RecLProdOL.FindFirst() then
                    RecLItemPF.Get(RecLProdOL."Item No.");
                RecLConfPF.SetRange("Item Code", RecLItemPF."No.");
                if not RecLConfPF.FindFirst() then
                    RecLConfPF.Init();

                //>>
                Lot1 := '';
                Qty1 := 0;
                Lot2 := '';
                Qty2 := 0;
                Lot3 := '';
                Qty3 := 0;
                Lot4 := '';
                Qty4 := 0;
                Clear(ConcatComponentNo);
                Clear(SumComponentQty);
                //<<

                //Determine l'article SO
                RecLProdOC.SetRange(Status, Status);
                RecLProdOC.SetRange("Prod. Order No.", "No.");
                //>>
                //IF RecLProdOC.FINDFIRST THEN BEGIN
                RecLProdOC.SetFilter("Quantity per", '<>%1', 0);
                if RecLProdOC.Find('-') then
                    repeat
                        //<<
                        RecLItemSO.Get(RecLProdOC."Item No.");
                        RecLConfSO.SetRange("Item Code", RecLItemSO."No.");
                        if not RecLConfSO.FindFirst() then
                            RecLConfSO.Init();

                        RecLReservation.Reset();
                        RecLReservation.SetRange("Source Type", DATABASE::"Prod. Order Component");
                        RecLReservation.SetRange("Source Subtype", 3);
                        RecLReservation.SetRange("Source ID", RecLProdOC."Prod. Order No.");
                        RecLReservation.SetRange("Source Prod. Order Line", RecLProdOC."Prod. Order Line No.");
                        RecLReservation.SetRange("Source Ref. No.", RecLProdOC."Line No.");
                        RecLReservation.SetFilter("Lot No.", '<>%1', '');
                        if RecLReservation.Find('-') then
                            repeat
                                case RecLReservation."Lot No." of
                                    Lot1:
                                        Qty1 += RecLReservation.Quantity;
                                    Lot2:
                                        Qty2 += RecLReservation.Quantity;
                                    Lot3:
                                        Qty3 += RecLReservation.Quantity;
                                    Lot4:
                                        Qty4 += RecLReservation.Quantity;
                                    else
                                        if Lot1 = '' then begin
                                            Lot1 := RecLReservation."Lot No.";
                                            Qty1 := RecLReservation.Quantity;
                                        end else
                                            if Lot2 = '' then begin
                                                Lot2 := RecLReservation."Lot No.";
                                                Qty2 := RecLReservation.Quantity;
                                            end else
                                                if Lot3 = '' then begin
                                                    Lot3 := RecLReservation."Lot No.";
                                                    Qty3 := RecLReservation.Quantity;
                                                    //END;
                                                end else
                                                    if Lot4 = '' then begin
                                                        Lot4 := RecLReservation."Lot No.";
                                                        Qty4 := RecLReservation.Quantity;
                                                    end;
                                end;
                            until RecLReservation.Next() = 0;

                        RecLItemLedgerEntry.Reset();
                        RecLItemLedgerEntry.SetRange("Entry Type", RecLItemLedgerEntry."Entry Type"::Consumption);
                        RecLItemLedgerEntry.SetRange("Document No.", "Production Order"."No.");
                        RecLItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
                        if RecLItemLedgerEntry.FindFirst() then
                            repeat
                                case RecLItemLedgerEntry."Lot No." of
                                    Lot1:
                                        Qty1 += Abs(RecLItemLedgerEntry.Quantity);
                                    Lot2:
                                        Qty2 += Abs(RecLItemLedgerEntry.Quantity);
                                    Lot3:
                                        Qty3 += Abs(RecLItemLedgerEntry.Quantity);
                                    Lot4:
                                        Qty4 += Abs(RecLItemLedgerEntry.Quantity);
                                    else
                                        if Lot1 = '' then begin
                                            Lot1 := RecLItemLedgerEntry."Lot No.";
                                            Qty1 := Abs(RecLItemLedgerEntry.Quantity);
                                        end else
                                            if Lot2 = '' then begin
                                                Lot2 := RecLItemLedgerEntry."Lot No.";
                                                Qty2 := Abs(RecLItemLedgerEntry.Quantity);
                                            end else
                                                if Lot3 = '' then begin
                                                    Lot3 := RecLItemLedgerEntry."Lot No.";
                                                    Qty3 := Abs(RecLItemLedgerEntry.Quantity);
                                                    //END;
                                                end else
                                                    if Lot4 = '' then begin
                                                        Lot4 := RecLReservation."Lot No.";
                                                        Qty4 := RecLReservation.Quantity;
                                                    end;
                                end;
                            until RecLItemLedgerEntry.Next() = 0;

                        //>>
                        SumComponentQty += RecLProdOC."Expected Quantity";
                        if ConcatComponentNo <> '' then
                            ConcatComponentNo += ' ';
                        ConcatComponentNo += RecLItemSO."No.";
                    until RecLProdOC.Next() = 0;
                //<<
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        RecLItemPF: Record Item;
        RecLItemSO: Record Item;
        RecLProdOC: Record "Prod. Order Component";
        RecLProdOL: Record "Prod. Order Line";
        RecLConfPF: Record "PWD Item Configurator";
        RecLConfSO: Record "PWD Item Configurator";
        CodLLotNo_component: Code[10];
        Lot1: Code[20];
        Lot2: Code[20];
        Lot3: Code[20];
        Lot4: Code[20];
        Qty1: Decimal;
        Qty2: Decimal;
        Qty3: Decimal;
        Qty4: Decimal;
        SumComponentQty: Decimal;
        "FICHE_SUIVEUSE__complément_technique_CaptionLbl": Label 'FICHE SUIVEUSE (complément technique) : ';
        FORMAT_CodLLotNo_component_CaptionLbl: Label 'Label1100267032';
        LotCaptionLbl: Label 'Lot No. :';
        Mesure_CaptionLbl: Label 'Nomin';
        Quantite_CaptionLbl: Label 'Quantité';
        RecLItemPF__LPSA_Description_1_CaptionLbl: Label 'Description :';
        RecLItemPF__LPSA_Description_2_CaptionLbl: Label 'Désignation LPSA2 :';
        RecLItemPF__No__CaptionLbl: Label 'Art. (Produit Fini) :';
        RecLItemSO__LPSA_Description_1_CaptionLbl: Label 'Description :';
        RecLItemSO__LPSA_Description_2_CaptionLbl: Label 'Désignation LPSA2 :';
        RecLItemSO__No__CaptionLbl: Label 'Art. (Semi-Ouvré) :';
        SO_CaptionLbl: Label 'Semi-ouvré';
        ConcatComponentNo: Text[100];


    procedure FctGetTolerence("Min": Decimal; "Max": Decimal): Text[30]
    begin
        if (Min = 0) and (Max = 0) then
            exit('0/0')
        else
            if (Abs(Min) = Abs(Max)) and (Min < 0) and (Max > 0) then
                exit('+/-' + Format(Max))
            else
                if (Min < 0) and (Max < 0) then
                    exit('-' + Format(Min) + '/-' + Format(Max))
                else
                    if (Min < 0) and (Max > 0) then
                        exit('-' + Format(Min) + '/+' + Format(Max))
                    else
                        if (Min > 0) and (Max < 0) then
                            exit('+' + Format(Min) + '/-' + Format(Max))
                        else
                            exit('+' + Format(Min) + '/+' + Format(Max));
    end;
}

