pageextension 60057 "PWD ContactList" extends "Contact List"
{
    layout
    {
        addafter("Search Name")
        {
            field("PWD Job Title"; Rec."Job Title")
            {
                ApplicationArea = All;
            }
        }
    }
}

