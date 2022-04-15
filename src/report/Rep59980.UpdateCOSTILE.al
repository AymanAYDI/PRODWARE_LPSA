report 59980 "PWD Update COST ILE"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateCOSTILE.rdl';

    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = SORTING("Item No.", "Variant Code", "Location Code", Status, "Due Date") WHERE(Status = CONST(Released), "Location Code" = CONST('PIE'));
            RequestFilterFields = Status, "Prod. Order No.";
            column(Prod__Order_Line_Status; Status)
            {
            }
            column(Prod__Order_Line_Prod__Order_No_; "Prod. Order No.")
            {
            }
            column(Prod__Order_Line_Line_No_; "Line No.")
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Prod. Order No." = FIELD("Prod. Order No.");
                DataItemTableView = WHERE("Entry Type" = CONST(Consumption));
                column(Item_Ledger_Entry__Entry_No__; "Entry No.")
                {
                }
                column(Item_Ledger_Entry__Item_No__; "Item No.")
                {
                }
                column(Item_Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(Item_Ledger_Entry_Description; Description)
                {
                }
                column(RecLOldEntrt__Posting_Date_; RecLOldEntrt."Posting Date")
                {
                }
                column(Item_Ledger_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(RecLItem__Unit_Cost_; RecLItem."Unit Cost")
                {
                }
                column(RecLItem__Standard_Cost_; RecLItem."Standard Cost")
                {
                }
                column(RecLItem__Costing_Method_; RecLItem."Costing Method")
                {
                }
                column(Item_Ledger_Entry_Prod__Order_No_; "Prod. Order No.")
                {
                }

                trigger OnAfterGetRecord()
                var
                    ItemApplnEntry: Record "Item Application Entry";
                    RecLILE: Record "Item Journal Line";
                    RecLItem2: Record Item;
                begin
                    CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
                    if ("Cost Amount (Actual)" = 0) and ("Cost Amount (Expected)" = 0) then begin
                        if RecLItem.Get("Item No.") then begin

                            //    IF RecLItem."Costing Method" <> RecLItem."Costing Method"::Average THEN
                            //      CurrReport.SKIP
                            //    ELSE BEGIN
                            //      IF Positive THEN BEGIN
                            //      END ELSE BEGIN
                            ItemApplnEntry.Reset();
                            ItemApplnEntry.SetCurrentKey("Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application");
                            ItemApplnEntry.SetRange("Outbound Item Entry No.", "Entry No.");
                            ItemApplnEntry.SetRange("Item Ledger Entry No.", "Entry No.");
                            ItemApplnEntry.SetRange("Cost Application", true);
                            if ItemApplnEntry.Find('-') then
                                repeat
                                    RecLOldEntrt.Get(ItemApplnEntry."Inbound Item Entry No.");

                                    if not RecLOldEntrt."Completely Invoiced" then
                                        CurrReport.Skip();
                                    RecLOldEntrt.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
                                    if not ((RecLOldEntrt."Cost Amount (Actual)" = 0) and (RecLOldEntrt."Cost Amount (Expected)" = 0)) then
                                        CurrReport.Skip();
                                //          RecLItem2.GET(RecLOldEntrt."Item No.");
                                //          RecLILE.RESET;
                                //          RecLILE.SETRANGE("Journal Template Name",'REEVAL');
                                //          RecLILE.SETRANGE("Journal Batch Name",'COUTS');
                                //          RecLILE.SETRANGE("Applies-to Entry",ItemApplnEntry."Inbound Item Entry No.");
                                /*  IF RecLILE.ISEMPTY THEN BEGIN
                                    RecLILE.INIT;
                                    RecLILE.VALIDATE("Journal Template Name",'REEVAL');
                                    RecLILE.VALIDATE("Journal Batch Name",'COUTS');
                                    RecLILE.VALIDATE("Line No.",IntG);
                                    RecLILE.VALIDATE("Entry Type",RecLOldEntrt."Document Type");
                                    RecLILE.VALIDATE("Value Entry Type",RecLILE."Value Entry Type"::Revaluation);
                                    RecLILE.VALIDATE("Document No.",'REVAL.');
                                    RecLILE.VALIDATE("Item No.",RecLOldEntrt."Item No.");
                                    RecLILE.INSERT;
                                    RecLILE.VALIDATE("Applies-to Entry",RecLOldEntrt."Entry No.");
                                    RecLILE.VALIDATE("Unit Cost (Revalued)",RecLItem2."Unit Cost");
                                    RecLILE.MODIFY;
                                    IntG += 10000;
                                   END;*/
                                until ItemApplnEntry.Next() = 0;
                            //      END;
                            //    END;
                        end;
                    end else
                        CurrReport.Skip();

                end;
            }

            trigger OnPreDataItem()
            var
                RecLILE: Record "Item Journal Line";
            begin
                RecLILE.Reset();
                RecLILE.SetRange("Journal Template Name", 'REEVAL');
                RecLILE.SetRange("Journal Batch Name", 'COUTS');
                if RecLILE.FindLast() then
                    IntG := RecLILE."Line No." + 10000
                else
                    IntG := 10000;
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
        IntG: Integer;
        RecLOldEntrt: Record "Item Ledger Entry";
        RecLItem: Record Item;
}

