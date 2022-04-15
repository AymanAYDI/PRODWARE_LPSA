report 99092 "PWD prod order without lot"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/prodorderwithoutlot.rdl';

    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = WHERE(Status = CONST(Released), "Remaining Quantity" = FILTER(> 0));
            PrintOnlyIfDetail = true;
            column(OFCaption; OFCaptionLbl)
            {
            }
            column(InitialeCaption; InitialeCaptionLbl)
            {
            }
            column(TerminesCaption; TerminesCaptionLbl)
            {
            }
            column(RestantesCaption; RestantesCaptionLbl)
            {
            }
            column(LigneCaption; LigneCaptionLbl)
            {
            }
            column(No_articleCaption; No_articleCaptionLbl)
            {
            }
            column(N__article_compo_Caption; N__article_compo_CaptionLbl)
            {
            }
            column(Designation1Caption; Designation1CaptionLbl)
            {
            }
            column(InitialeCaption_Control1000000027; InitialeCaption_Control1000000027Lbl)
            {
            }
            column(TerminesCaption_Control1000000028; TerminesCaption_Control1000000028Lbl)
            {
            }
            column(RestantesCaption_Control1000000029; RestantesCaption_Control1000000029Lbl)
            {
            }
            column(OFCaption_Control1000000019; OFCaption_Control1000000019Lbl)
            {
            }
            column(LigneCaption_Control1000000020; LigneCaption_Control1000000020Lbl)
            {
            }
            column(No_articleCaption_Control1000000021; No_articleCaption_Control1000000021Lbl)
            {
            }
            column(N__article_compo_Caption_Control1000000023; N__article_compo_Caption_Control1000000023Lbl)
            {
            }
            column(Designation1Caption_Control1000000024; Designation1Caption_Control1000000024Lbl)
            {
            }
            column(Prod__Order_Line_Status; Status)
            {
            }
            column(Prod__Order_Line_Prod__Order_No_; "Prod. Order No.")
            {
            }
            column(Prod__Order_Line_Line_No_; "Line No.")
            {
            }
            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Prod. Order Line No." = FIELD("Line No.");
                DataItemTableView = WHERE("Remaining Quantity" = FILTER(<> 0));
                column(Prod__Order_Component__Item_No__; "Item No.")
                {
                }
                column(Prod__Order_Line___Remaining_Quantity_; "Prod. Order Line"."Remaining Quantity")
                {
                }
                column(Prod__Order_Line___Finished_Quantity_; "Prod. Order Line"."Finished Quantity")
                {
                }
                column(Prod__Order_Line__Quantity; "Prod. Order Line".Quantity)
                {
                }
                column(Prod__Order_Line__Description; "Prod. Order Line".Description)
                {
                }
                column(Prod__Order_Line___Item_No__; "Prod. Order Line"."Item No.")
                {
                }
                column(Prod__Order_Line___Line_No__; "Prod. Order Line"."Line No.")
                {
                }
                column(Prod__Order_Line___Prod__Order_No__; "Prod. Order Line"."Prod. Order No.")
                {
                }
                column(Prod__Order_Component_Status; Status)
                {
                }
                column(Prod__Order_Component_Prod__Order_No_; "Prod. Order No.")
                {
                }
                column(Prod__Order_Component_Prod__Order_Line_No_; "Prod. Order Line No.")
                {
                }
                column(Prod__Order_Component_Line_No_; "Line No.")
                {
                }

                trigger OnAfterGetRecord()
                var
                    RecL367: Record "Reservation Entry";
                begin
                    RecL367.Reset();
                    RecL367.SetRange("Source Type", 5407);
                    //RecL367.SETRANGE("Source Subtype",3);
                    RecL367.SetRange("Source ID", "Prod. Order Line"."Prod. Order No.");
                    RecL367.SetRange("Source Prod. Order Line", "Prod. Order Line"."Line No.");
                    RecL367.SetRange("Source Ref. No.", "Prod. Order Component"."Line No.");
                    RecL367.SetRange("Lot No.", '<>''');

                    if RecL367.FindFirst() then
                        CurrReport.Skip();
                end;
            }
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
        OFCaptionLbl: Label 'OF';
        InitialeCaptionLbl: Label 'Initiale';
        TerminesCaptionLbl: Label 'Termines';
        RestantesCaptionLbl: Label 'Restantes';
        LigneCaptionLbl: Label 'Ligne';
        No_articleCaptionLbl: Label 'No article';
        N__article_compo_CaptionLbl: Label 'N? article compo.';
        Designation1CaptionLbl: Label 'Designation1';
        InitialeCaption_Control1000000027Lbl: Label 'Initiale';
        TerminesCaption_Control1000000028Lbl: Label 'Termines';
        RestantesCaption_Control1000000029Lbl: Label 'Restantes';
        OFCaption_Control1000000019Lbl: Label 'OF';
        LigneCaption_Control1000000020Lbl: Label 'Ligne';
        No_articleCaption_Control1000000021Lbl: Label 'No article';
        N__article_compo_Caption_Control1000000023Lbl: Label 'N? article compo.';
        Designation1Caption_Control1000000024Lbl: Label 'Designation1';
}

