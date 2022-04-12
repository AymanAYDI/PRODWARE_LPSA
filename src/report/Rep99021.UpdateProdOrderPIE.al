report 99021 "PWD Update Prod Order PIE"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateProdOrderPIE.rdl';

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING(Status, "No.") WHERE(Status = CONST(Released), "Location Code" = CONST('PIE'));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Source No.";
            column(Production_Order__No__; "No.")
            {
            }
            column(Production_Order__Source_No__; "Source No.")
            {
            }
            column(Production_Order_Quantity; Quantity)
            {
            }
            column(Production_Order__No__Caption; FieldCaption("No."))
            {
            }
            column(Production_Order__Source_No__Caption; FieldCaption("Source No."))
            {
            }
            column(Production_Order_Status; Status)
            {
            }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.");
                column(Prod__Order_Line__Item_No__; "Item No.")
                {
                }
                column(Prod__Order_Line_Description; Description)
                {
                }
                column(Prod__Order_Line_Quantity; Quantity)
                {
                }
                column(Prod__Order_Line__Item_No__Caption; FieldCaption("Item No."))
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
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                    column(Prod__Order_Component__Item_No__; "Item No.")
                    {
                    }
                    column(Prod__Order_Component_Description; Description)
                    {
                    }
                    column(Prod__Order_Component_Quantity; Quantity)
                    {
                    }
                    column(Prod__Order_Component__Expected_Quantity_; "Expected Quantity")
                    {
                    }
                    column(Prod__Order_Component__Remaining_Quantity_; "Remaining Quantity")
                    {
                    }
                    column(Prod__Order_Component__Item_No__Caption; FieldCaption("Item No."))
                    {
                    }
                    column(Prod__Order_Component_QuantityCaption; FieldCaption(Quantity))
                    {
                    }
                    column(Prod__Order_Component__Expected_Quantity_Caption; FieldCaption("Expected Quantity"))
                    {
                    }
                    column(Prod__Order_Component__Remaining_Quantity_Caption; FieldCaption("Remaining Quantity"))
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
                    begin
                        "Remaining Quantity" := 0;
                        "Remaining Qty. (Base)" := 0;
                        Modify;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                ProdOrderComp.SetRange(Status, Status);
                ProdOrderComp.SetRange("Prod. Order No.", "No.");

                if not ProdOrderComp.FindFirst then
                    CurrReport.Skip;
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
        ProdOrderComp: Record "Prod. Order Component";
}

