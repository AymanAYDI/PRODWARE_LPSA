report 99085 "PWD Update Gammes avec TTE OPE"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateGammesavecTTEOPE.rdl';

    dataset
    {
        dataitem("Routing Header"; "Routing Header")
        {
            DataItemTableView = WHERE("No." = FILTER(<> 'PIE_TT_OPE_PIERRE'), PlanningGroup = FILTER(<> 'PIERRES'));
            dataitem("Routing Line"; "Routing Line")
            {
                DataItemLink = "Routing No." = FIELD("No.");
                DataItemTableView = WHERE(Type = CONST("Machine Center"));

                trigger OnAfterGetRecord()
                var
                    RecLRL: Record "Routing Line";
                begin
                    RecLRL.SetRange(RecLRL."Routing No.", 'PIE_TT_OPE_PIERRE');
                    RecLRL.SetRange(Type, Type);
                    RecLRL.SetRange("No.", "No.");
                    if RecLRL.FindFirst() then begin
                        Validate("Setup Time", RecLRL."Setup Time");
                        Validate("Run Time", RecLRL."Run Time");
                        Validate("Wait Time", RecLRL."Wait Time");
                        Validate("Move Time", RecLRL."Move Time");
                        Validate("Setup Time Unit of Meas. Code", RecLRL."Setup Time Unit of Meas. Code");
                        Validate("Run Time Unit of Meas. Code", RecLRL."Run Time Unit of Meas. Code");
                        Validate("Wait Time Unit of Meas. Code", RecLRL."Wait Time Unit of Meas. Code");
                        Validate("Move Time Unit of Meas. Code", RecLRL."Move Time Unit of Meas. Code");
                        Modify(true);
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if Stat <> Stat::"Under Development" then begin
                        "Routing Header".Validate(Status, Stat);
                        "Routing Header".Modify(true);
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Stat := Status;
                if Stat <> Stat::"Under Development" then begin
                    Validate(Status, Status::"Under Development");
                    Modify(true);
                end;
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
        Stat: Option New,Certified,"Under Development",Closed;
}

