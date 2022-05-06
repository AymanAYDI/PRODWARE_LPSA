report 50047 "Create Dedicated Item Routing"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.20
    // P24578_007 : RO 01/10/2019 : New report
    // 
    // ------------------------------------------------------------------------------------------------------------------

    Caption = 'Create Dedicated Item Routing';
    ProcessingOnly = true;
    UsageCategory = none;
    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "PWD LPSA Description 1", "PWD LPSA Description 2";

            trigger OnAfterGetRecord()
            begin
                IntGCounter -= 1;
                Bdialog.Update(1, IntGCounter);
                Bdialog.Update(2, Item."No.");

                // création gamme
                RecGRoutingHeader.Init();

                if BooGAddUnderscore then
                    RecGRoutingHeader.Validate("No.", CodGPrefixe + '_' + Item."No.")
                else
                    RecGRoutingHeader.Validate("No.", CodGPrefixe + Item."No.");

                if not RecGRoutingHeader.Insert(true) then
                    if Confirm(CstG004, false, RecGRoutingHeader."No.") then begin
                        if (RecGRoutingHeader.Status <> RecGRoutingHeader.Status::"Under Development") then begin
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

                        RecGRoutingHeader.Insert(true);
                    end else
                        CurrReport.Skip();

                // copie gamme
                CduGCopyRouting.CopyRouting(CodGGenericRouting, '', RecGRoutingHeader, '');

                RecGRoutingHeaderGeneric.Get(CodGGenericRouting);
                RecGRoutingHeader.Validate(Description, RecGRoutingHeaderGeneric.Description);
                RecGRoutingHeader.Validate("Search Description", RecGRoutingHeaderGeneric."Search Description");
                //RecGRoutingHeader.Validate(PlanningGroup, RecGRoutingHeaderGeneric.PlanningGroup);

                RecGRoutingHeader.Validate(Status, RecGRoutingHeader.Status::Certified);

                RecGRoutingHeader.Modify(true);

                // affectation de la gamme à l'article
                Item.Validate("Routing No.", RecGRoutingHeader."No.");
                Item.Modify();
            end;

            trigger OnPostDataItem()
            begin
                Bdialog.Close();
                Message('Traitement terminé');
            end;

            trigger OnPreDataItem()
            begin
                IntGCounter := Count;
                Bdialog.Open('Articles restants #1############\Article en cours #2############');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(CodGGenericRoutingF; CodGGenericRouting)
                {
                    Caption = 'Generic routing';
                    ShowCaption = false;
                    TableRelation = "Routing Header";
                    ApplicationArea = All;
                }
                field(CodGPrefixeF; CodGPrefixe)
                {
                    Caption = 'Prefixe';
                    ShowCaption = false;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CodGPrefixe := CopyStr(CodGGenericRouting, 1, 6);
                    end;
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

    trigger OnPreReport()
    begin
        if Item.GetFilters = '' then
            Error(CstG001);

        if CodGGenericRouting = '' then
            Error(CstG002);

        if CodGPrefixe = '' then
            Error(CstG003);

        // Vérification de la terminaison du préfixe
        if CopyStr(CodGPrefixe, StrLen(CodGPrefixe), 1) = '_' then
            BooGAddUnderscore := false
        else
            BooGAddUnderscore := true;
    end;

    var
        RecGMfgComment: Record "Manufacturing Comment Line";
        RecGRoutingHeader: Record "Routing Header";
        RecGRoutingHeaderGeneric: Record "Routing Header";
        RecGRtngLine: Record "Routing Line";
        RecGRtngVersion: Record "Routing Version";
        CduGCopyRouting: Codeunit "Routing Line-Copy Lines";
        BooGAddUnderscore: Boolean;
        CodGPrefixe: Code[6];
        CodGGenericRouting: Code[20];
        Bdialog: Dialog;
        IntGCounter: Integer;
        CstG001: Label 'Item must be filter.';
        CstG002: Label 'Generic routing must not be empty !';
        CstG003: Label 'Prefixe must not be empty !';
        CstG004: Label 'The routing %1 is already existing, do you want to replace it ?';
}

