pageextension 50107 pageextension50107 extends "Purchase Agent Activities"
{
    layout
    {
        addafter("Control 18")
        {
            cuegroup("Purchase Orders - Authorize for Payment")
            {
                Caption = 'Purchase Orders - Authorize for Payment';
                field("To be approuved"; "To be approuved")
                {
                    DrillDownFormID = Approval Request Entries;
                    ApplicationArea = All;
                }
            }
        }
    }


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    RESET;
    IF NOT GET THEN BEGIN
      INIT;
      INSERT;
    END;

    SETFILTER("Date Filter",'>=%1',WORKDATE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..7
    //>>TEST NICO
    SETFILTER("UserID Filter",USERID);
    //<<TEST NICO
    */
    //end;
}

