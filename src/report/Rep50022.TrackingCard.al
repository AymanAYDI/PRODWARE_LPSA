report 50022 "PWD Tracking Card"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 23/10/2017 : FICHE SUIVEUSE - PP 1
    //                   - new report
    // 
    // //>>LAP2.23
    // TDL100220.001 : Ajout information pied de page
    //                 Ajout regle sur le magasin acier
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/TrackingCard.rdl';
    UsageCategory = None;
    Caption = 'Tracking Card';

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            RequestFilterFields = Status, "No.";
            column(RecGCompanyInformation_Picture; RecGCompanyInformation.Picture)
            {
            }
            column(Production_Order__No__; "No.")
            {
            }
            column(Production_Order__Source_No__; "Source No.")
            {
            }
            column(Production_Order__Search_Description_; "Search Description")
            {
            }
            column(RecGItem__LPSA_Description_1______RecGItem__LPSA_Description_2_; RecGItem."PWD LPSA Description 1" + ' ' + RecGItem."PWD LPSA Description 2")
            {
            }
            column(Production_Order_Quantity; Quantity)
            {
            }
            column(TRACKING_CARDCaption; TRACKING_CARDCaptionLbl)
            {
            }
            column(ItemCaption; ItemCaptionLbl)
            {
            }
            column(Tabel___Caption; Tabel___CaptionLbl)
            {
            }
            column(Production_Order_QuantityCaption; Production_Order_QuantityCaptionLbl)
            {
            }
            column(Production_Order_Status; Status)
            {
            }
            dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.");
                column(Prod__Order_Routing_Line_Description; Description)
                {
                }
                column(Prod__Order_No___FORMAT__Routing_Reference_No_____Operation_No__; TxtGID)
                {
                }
                column(Prod__Order_Routing_Line__Operation_No__; "Operation No.")
                {
                }
                column(BooGShowBarCode; BooGShowBarCode)
                {
                }
                column(USERID; UserId)
                {
                }
                column(FORMAT_TODAY_0_4_; Format(CurrentDateTime, 0))
                {
                }
                column(Prod__Order_Routing_Line__Operation_No__Caption; FieldCaption("Operation No."))
                {
                }
                column(Prod__Order_Routing_Line_Status; Status)
                {
                }
                column(Prod__Order_Routing_Line_Prod__Order_No_; "Prod. Order No.")
                {
                }
                column(Prod__Order_Routing_Line_Routing_Reference_No_; "Routing Reference No.")
                {
                }
                column(Prod__Order_Routing_Line_Routing_No_; "Routing No.")
                {
                }
                column(Prod__Order_Routing_Line_Routing_Link_Code; "Routing Link Code")
                {
                }
                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Routing Link Code" = FIELD("Routing Link Code");
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                    column(Prod__Order_Component__Item_No__; "Item No.")
                    {
                    }
                    column(Prod__Order_Component_Description; Description)
                    {
                    }
                    column(Prod__Order_Component_Quantity; "Expected Quantity")
                    {
                    }
                    column(BooGComponent; BooGComponent)
                    {
                    }
                    column(Prod__Order_Component__Item_No__Caption; Prod__Order_Component__Item_No__CaptionLbl)
                    {
                    }
                    column(Prod__Order_Component_DescriptionCaption; FieldCaption(Description))
                    {
                    }
                    column(Prod__Order_Component_QuantityCaption; Prod__Order_Component_QuantityCaptionLbl)
                    {
                    }
                    column(Components_ListCaption; Components_ListCaptionLbl)
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
                    column(Prod__Order_Component_Routing_Link_Code; "Routing Link Code")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        BooGComponent := true;
                    end;

                    trigger OnPostDataItem()
                    begin
                        BooGComponent := false;
                    end;

                    trigger OnPreDataItem()
                    begin
                        BooGComponent := false;
                    end;
                }
                dataitem("Prod. Order Routing Tool"; "Prod. Order Routing Tool")
                {
                    DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Routing Reference No." = FIELD("Routing Reference No."), "Routing No." = FIELD("Routing No."), "Operation No." = FIELD("Operation No.");
                    DataItemTableView = SORTING("PWD Type", "No.");
                    column(Prod__Order_Routing_Tool__No__; "No.")
                    {
                    }
                    column(Prod__Order_Routing_Tool_Description; Description)
                    {
                    }
                    column(Prod__Order_Routing_Tool_Type; "PWD Type")
                    {
                    }
                    column(Prod__Order_Routing_Tool_Criteria; "PWD Criteria")
                    {
                    }
                    column(BooGRootingTool; BooGRootingTool)
                    {
                    }
                    column(Prod__Order_Routing_Tool__No__Caption; FieldCaption("No."))
                    {
                    }
                    column(Prod__Order_Routing_Tool_DescriptionCaption; FieldCaption(Description))
                    {
                    }
                    column(Tools_ListCaption; Tools_ListCaptionLbl)
                    {
                    }
                    column(Prod__Order_Routing_Tool_TypeCaption; FieldCaption("PWD Type"))
                    {
                    }
                    column(Prod__Order_Routing_Tool_CriteriaCaption; FieldCaption("PWD Criteria"))
                    {
                    }
                    column(Prod__Order_Routing_Tool_Status; Status)
                    {
                    }
                    column(Prod__Order_Routing_Tool_Prod__Order_No_; "Prod. Order No.")
                    {
                    }
                    column(Prod__Order_Routing_Tool_Routing_Reference_No_; "Routing Reference No.")
                    {
                    }
                    column(Prod__Order_Routing_Tool_Routing_No_; "Routing No.")
                    {
                    }
                    column(Prod__Order_Routing_Tool_Operation_No_; "Operation No.")
                    {
                    }
                    column(Prod__Order_Routing_Tool_Line_No_; "Line No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        BooGRootingTool := true;
                    end;

                    trigger OnPostDataItem()
                    begin
                        BooGRootingTool := false;
                    end;

                    trigger OnPreDataItem()
                    begin
                        BooGRootingTool := false;
                    end;
                }
                dataitem("Prod. Order Rtng Comment Line"; "Prod. Order Rtng Comment Line")
                {
                    DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Routing Reference No." = FIELD("Routing Reference No."), "Routing No." = FIELD("Routing No."), "Operation No." = FIELD("Operation No.");
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.", "Line No.");
                    column(Prod__Order_Rtng_Comment_Line_Comment; Comment)
                    {
                    }
                    column(BooGComment; BooGComment)
                    {
                    }
                    column(CommentCaption; FieldCaption(Comment))
                    {
                    }
                    column(Prod__Order_Rtng_Comment_Line_Status; Status)
                    {
                    }
                    column(Prod__Order_Rtng_Comment_Line_Prod__Order_No_; "Prod. Order No.")
                    {
                    }
                    column(Prod__Order_Rtng_Comment_Line_Routing_Reference_No_; "Routing Reference No.")
                    {
                    }
                    column(Prod__Order_Rtng_Comment_Line_Routing_No_; "Routing No.")
                    {
                    }
                    column(Prod__Order_Rtng_Comment_Line_Operation_No_; "Operation No.")
                    {
                    }
                    column(Prod__Order_Rtng_Comment_Line_Line_No_; "Line No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        BooGComment := true;
                    end;

                    trigger OnPostDataItem()
                    begin
                        BooGComment := false;
                    end;

                    trigger OnPreDataItem()
                    begin
                        BooGComment := false;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if ("Prod. Order Routing Line".Type = "Prod. Order Routing Line".Type::"Machine Center") and
                       RecGMachineCenter.Get("Prod. Order Routing Line"."No.") and
                       RecGMachineCenter."PWD To Excl. In Tracking Card" then
                        CurrReport.Skip();

                    if ("Prod. Order Routing Line".Type = "Prod. Order Routing Line".Type::"Work Center") then
                        CurrReport.Skip();

                    TxtGID := "Prod. Order No." + Format("Routing Reference No.") + "Operation No.";

                    if "Prod. Order Routing Line"."Flushing Method" = "Prod. Order Routing Line"."Flushing Method"::Backward then
                        BooGShowBarCode := false
                    else
                        BooGShowBarCode := true;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if not RecGItem.Get("Production Order"."Source No.") then RecGItem.Init();
                if "Production Order"."Source Type" <> "Production Order"."Source Type"::Item then RecGItem.Init();
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

    trigger OnPreReport()
    begin
        RecGCompanyInformation.Get();
        RecGCompanyInformation.CalcFields(Picture);
    end;

    var
        RecGCompanyInformation: Record "Company Information";
        RecGItem: Record Item;
        RecGMachineCenter: Record "Machine Center";
        BooGComment: Boolean;
        BooGComponent: Boolean;
        BooGRootingTool: Boolean;
        BooGShowBarCode: Boolean;
        Components_ListCaptionLbl: Label 'Components List';
        ItemCaptionLbl: Label 'Item No.';
        Prod__Order_Component__Item_No__CaptionLbl: Label 'Code';
        Prod__Order_Component_QuantityCaptionLbl: Label 'Out Quantity';
        Production_Order_QuantityCaptionLbl: Label 'Waiting Quantity';
        Tabel___CaptionLbl: Label 'Tabel : ';
        Tools_ListCaptionLbl: Label 'Tools List';
        TRACKING_CARDCaptionLbl: Label 'TRACKING CARD';
        TxtGID: Text[250];
}

