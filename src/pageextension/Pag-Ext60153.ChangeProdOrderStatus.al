pageextension 60153 "PWD ChangeProdOrderStatus" extends "Change Production Order Status"
{
    //TODO: modif dans l'action "Change &Status"
    layout
    {
        addbefore("No.")
        {
            field("PWD Selection"; "PWD Selection")
            {
                ApplicationArea = All;
            }
        }
        modify(Control1)
        {
            Editable = true;
        }
        modify("No.")
        {
            Editable = false;
        }
        modify(Description)
        {
            Editable = false;
        }
        modify("Creation Date")
        {
            Editable = false;
        }
        modify("Source Type")
        {
            Editable = false;
        }
        modify("Source No.")
        {
            Editable = false;
        }
        modify("Starting Time")
        {
            Editable = false;
        }
        modify("Starting Date")
        {
            Editable = false;
        }
        modify("Ending Time")
        {
            Editable = false;
        }
        modify("Ending Date")
        {
            Editable = false;
        }
        modify("Due Date")
        {
            Editable = false;
        }
        modify("Finished Date")
        {
            Editable = false;
        }

    }
}
