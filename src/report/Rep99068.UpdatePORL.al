report 99068 "PWD Update PORL"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdatePORL.rdl';

    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = WHERE(Status = FILTER(<= Released), "Location Code" = FILTER(<> 'ACI'));
            dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
            {
                DataItemLink = "Prod. Order No." = FIELD("Prod. Order No."), Status = FIELD(Status);
                DataItemTableView = WHERE(Status = FILTER(<= Released));

                trigger OnAfterGetRecord()
                begin
                    /*PORLB.SETRANGE(Status,Status);
                    
                    PORLB.SETRANGE("Prod. Order No.","Prod. Order No.");
                    PORLB.SETRANGE("Routing Reference No.","Routing Reference No.");
                    PORLB.SETRANGE("Operation No.","Operation No.");
                    IF PORLB.FINDFIRST THEN BEGIN
                      IF RH.GET(PORLB."Routing No.") AND (RH.Status =RH.Status::Certified) THEN BEGIN
                        "Routing No." :=  PORLB."Routing No.";
                        MODIFY;
                      END ELSE BEGIN
                        tmp.INIT;
                        tmp."N° Gamme" := "Prod. Order No.";
                        tmp.INSERT;
                      END;
                    END;*/

                    //  IF RH.GET("Prod. Order Line"."Routing No.") AND (RH.Status =RH.Status::Certified) THEN BEGIN

                    //    "Routing No." :=  "Prod. Order Line"."Routing No.";
                    //   RENAME(Status,"Prod. Order No.","Routing Reference No.", "Prod. Order Line"."Routing No.","Operation No.")
                    //           END;

                end;
            }

            trigger OnAfterGetRecord()
            begin
                PORL.SetRange("Prod. Order No.", "Prod. Order Line"."Prod. Order No.");
                if PORL.FindFirst() then
                    repeat
                        PORL2.Get(PORL.Status, PORL."Prod. Order No.",
                          PORL."Routing Reference No.",
                          PORL."Routing No.",
                          PORL."Operation No.");
                        PORL2.Rename(PORL.Status, PORL."Prod. Order No.",
                          PORL."Routing Reference No.",
                          "Prod. Order Line"."Routing No.",
                          PORL."Operation No.");
                    until PORL.Next() = 0;
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
        PORL: Record "Prod. Order Routing Line";
        PORL2: Record "Prod. Order Routing Line";
}

