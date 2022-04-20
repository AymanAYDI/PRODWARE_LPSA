pageextension 50099 pageextension50099 extends "Bin Contents"
{
    layout
    {
        addafter("Control 5")
        {
            field(RecGItem."LPSA Description 1";
                RecGItem."LPSA Description 1")
            {
                Caption = 'Désignation LPSA 1';
                Editable = false;
                ApplicationArea = All;
            }
            field(RecGItem."LPSA Description 2";
                RecGItem."LPSA Description 2")
            {
                Caption = 'Désignation LPSA 2';
                Editable = false;
                ApplicationArea = All;
            }
        }
    }

    var
        "- LAP2.08 -": Integer;
        RecGItem: Record "27";


    //Unsupported feature: Code Modification on "OnAfterGetCurrRecord(PROCEDURE 19077479)".

    //procedure OnAfterGetCurrRecord();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    xRec := Rec;
    GetItemDescr("Item No.","Variant Code",ItemDescription);
    DataCaption := STRSUBSTNO('%1 ',"Bin Code");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3

    //>>LAP2.08
    IF NOT RecGItem.GET("Item No.") THEN
      RecGItem.INIT;
    //<<LAP2.08
    */
    //end;
}

