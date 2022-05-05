report 50018 "PWD Update Routing Line"
{
    Caption = 'Update routing lines';
    ProcessingOnly = true;
    UseRequestPage = false;
    UseSystemPrinter = false;
    UsageCategory = none;

    dataset
    {
        dataitem(RL_Reference; "Routing Line")
        {
            DataItemTableView = SORTING("Routing No.", "Version Code", "Operation No.");
            dataitem(RL_Others; "Routing Line")
            {
                DataItemLink = Type = FIELD(Type), "No." = FIELD("No.");
                DataItemTableView = SORTING("Routing No.", "Version Code", "Operation No.");

                trigger OnAfterGetRecord()
                begin
                    if not ((RL_Others."Routing No." = RL_Reference."Routing No.") and
                      (RL_Others."Version Code" = RL_Reference."Version Code")) then begin
                        RecGRoutingHeader.Get(RL_Others."Routing No.");
                        if RecGRoutingHeader.Status <> RecGRoutingHeader.Status::Closed then begin
                            Stat := RecGRoutingHeader.Status;

                            if (Stat <> Stat::"Under Development") and (Stat <> Stat::Closed) then begin
                                RecGRoutingHeader.Validate(Status, RecGRoutingHeader.Status::"Under Development");
                                RecGRoutingHeader.Modify(true);
                            end;

                            Validate("Setup Time", RL_Reference."Setup Time");
                            Validate("Run Time", RL_Reference."Run Time");
                            Validate("Wait Time", RL_Reference."Wait Time");
                            Validate("Move Time", RL_Reference."Move Time");
                            Validate("Setup Time Unit of Meas. Code", RL_Reference."Setup Time Unit of Meas. Code");
                            Validate("Run Time Unit of Meas. Code", RL_Reference."Run Time Unit of Meas. Code");
                            Validate("Wait Time Unit of Meas. Code", RL_Reference."Wait Time Unit of Meas. Code");
                            Validate("Move Time Unit of Meas. Code", RL_Reference."Move Time Unit of Meas. Code");
                            RL_Others.Modify(true);

                            if (Stat <> Stat::"Under Development") and (Stat <> Stat::Closed) then begin
                                RecGRoutingHeader.Validate(Status, Stat);
                                RecGRoutingHeader.Modify(true);
                            end;

                        end;
                    end;
                end;
            }
            dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
            {
                DataItemLink = Type = FIELD(Type), "No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.") WHERE(Status = FILTER(< Finished), "Routing Status" = FILTER(< Finished));

                trigger OnAfterGetRecord()
                var
                    RecLMachineCenter: Record "Machine Center";
                    RecLWorkCenter: Record "Work Center";
                begin
                    Validate("Setup Time", RL_Reference."Setup Time");
                    Validate("Run Time", RL_Reference."Run Time");
                    Validate("Wait Time", RL_Reference."Wait Time");
                    Validate("Move Time", RL_Reference."Move Time");
                    Validate("Setup Time Unit of Meas. Code", RL_Reference."Setup Time Unit of Meas. Code");
                    Validate("Run Time Unit of Meas. Code", RL_Reference."Run Time Unit of Meas. Code");
                    Validate("Wait Time Unit of Meas. Code", RL_Reference."Wait Time Unit of Meas. Code");
                    Validate("Move Time Unit of Meas. Code", RL_Reference."Move Time Unit of Meas. Code");

                    if "Prod. Order Routing Line".Type = "Prod. Order Routing Line".Type::"Work Center" then begin
                        RecLWorkCenter.Get("Prod. Order Routing Line"."No.");
                        "Prod. Order Routing Line".Validate("Unit Cost per", RecLWorkCenter."Unit Cost");
                    end else begin
                        RecLMachineCenter.Get("Prod. Order Routing Line"."No.");
                        "Prod. Order Routing Line".Validate("Unit Cost per", RecLMachineCenter."Unit Cost");
                    end;

                    Modify(true);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if not Confirm(StrSubstNo(TxtG001, Type, "No.", "Operation No.")) then
                    CurrReport.Break();
            end;

            trigger OnPostDataItem()
            begin
                Message(TxtG002);
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
        RecGRoutingHeader: Record "Routing Header";
        TxtG001: Label 'Warning, you are about to update all routings and production orders related to %1 %2 and operation no. %3.';
        TxtG002: Label 'Updated finished.';
        Stat: Option New,Certified,"Under Development",Closed;
}

