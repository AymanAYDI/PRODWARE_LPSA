report 50082 "PWD UPDATE COST"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = WHERE(Status = CONST(Released), "Location Code" = FILTER(<> 'ACI'));
            RequestFilterFields = Status, "No.";
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.");
                dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
                {
                    DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Routing Reference No." = FIELD("Line No."), "Routing No." = FIELD("Routing No.");
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.") WHERE("Routing Link Code" = FILTER(= ''));
                    dataitem("Capacity Ledger Entry"; "Capacity Ledger Entry")
                    {
                        DataItemLink = "Order No." = FIELD("Prod. Order No."), "Operation No." = FIELD("Operation No.");
                        DataItemTableView = SORTING("Order No.", "Order Line No.", "Routing No.", "Routing Reference No.", "Operation No.", "Last Output Line");

                        trigger OnAfterGetRecord()
                        var
                            RecLRoutingLine: Record "Routing Line";
                            RecMachine: Record "Machine Center";
                            RecWOrk: Record "Work Center";
                            RecLItem: Record Item;
                        begin
                            RecLItem.Get("Production Order"."Source No.");
                            if not RecLItem.Blocked then begin
                                RecGIJL.Init();
                                RecGIJL.Validate("Journal Template Name", 'PRODUCTION');
                                RecGIJL.Validate("Journal Batch Name", 'AJUSTEMENT');
                                RecGIJL.Validate("Line No.", IntG);
                                RecGIJL.Validate("Posting Date", WorkDate());
                                RecGIJL.Validate("Entry Type", RecGIJL."Entry Type"::Output);
                                RecGIJL.Validate("Order No.", "Production Order"."No.");
                                RecGIJL.Validate("Order Line No.", "Prod. Order Routing Line"."Routing Reference No.");
                                RecGIJL.Validate("Item No.", "Production Order"."Source No.");
                                RecGIJL.Validate("Location Code", "Production Order"."Location Code");
                                RecGIJL.Validate("Routing Reference No.", "Prod. Order Routing Line"."Routing Reference No.");
                                RecGIJL.Validate("Operation No.", "Capacity Ledger Entry"."Operation No.");
                                RecGIJL.Validate("Run Time", -"Run Time");
                                RecGIJL.Validate("Setup Time", -"Setup Time");
                                CalcFields("Direct Cost");
                                if "Run Time" <> 0 then
                                    RecGIJL.Validate("Unit Cost", "Capacity Ledger Entry"."Direct Cost" / "Run Time")
                                else
                                    RecGIJL.Validate("Unit Cost", 0);
                                if "Prod. Order Routing Line"."Routing Status" = "Prod. Order Routing Line"."Routing Status"::Finished then
                                    RecGIJL.Validate(Finished, true);
                                RecGIJL.Insert(true);
                                IntG += 10000;


                                RecGIJL.Init();
                                RecGIJL.Validate("Journal Template Name", 'PRODUCTION');
                                RecGIJL.Validate("Journal Batch Name", 'AJUSTEMENT');
                                RecGIJL.Validate("Line No.", IntG);
                                RecGIJL.Validate("Posting Date", WorkDate());
                                RecGIJL.Validate("Entry Type", RecGIJL."Entry Type"::Output);
                                RecGIJL.Validate("Order No.", "Production Order"."No.");
                                RecGIJL.Validate("Order Line No.", "Prod. Order Routing Line"."Routing Reference No.");
                                RecGIJL.Validate("Item No.", "Production Order"."Source No.");
                                RecGIJL.Validate("Location Code", "Production Order"."Location Code");
                                RecGIJL.Validate("Routing Reference No.", "Prod. Order Routing Line"."Routing Reference No.");
                                RecGIJL.Validate("Operation No.", "Capacity Ledger Entry"."Operation No.");
                                if "Prod. Order Routing Line"."Routing Status" = "Prod. Order Routing Line"."Routing Status"::Finished then
                                    RecGIJL.Validate(Finished, true);

                                RecLRoutingLine.SetRange("Routing No.", 'TT_OPE_PIE');
                                RecLRoutingLine.SetRange(Type, Type);
                                RecLRoutingLine.SetRange("No.", "No.");
                                if RecLRoutingLine.FindFirst() then begin
                                    RecGIJL.Validate("Run Time", RecLRoutingLine."Run Time" * "Prod. Order Routing Line"."Input Quantity");
                                    RecGIJL.Validate("Setup Time", RecLRoutingLine."Setup Time");
                                end;
                                if Type = Type::"Work Center" then begin
                                    RecWOrk.Get("No.");
                                    RecGIJL.Validate("Unit Cost", RecWOrk."Direct Unit Cost")
                                end else begin
                                    RecMachine.Get("No.");
                                    RecGIJL.Validate("Unit Cost", RecMachine."Direct Unit Cost")
                                end;
                                RecGIJL.Insert(true);
                                IntG += 10000;
                            end;
                        end;
                    }
                }
            }

            trigger OnPreDataItem()
            begin
                IntG := 10000;
                RecGIJL.Reset();
                RecGIJL.SetRange("Journal Template Name", 'PRODUCTION');
                RecGIJL.SetRange("Journal Batch Name", 'AJUSTEMENT');
                if RecGIJL.FindLast() then
                    IntG := RecGIJL."Line No." + 10000
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
        RecGIJL: Record "Item Journal Line";
}

