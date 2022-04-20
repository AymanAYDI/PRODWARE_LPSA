pageextension 60057 "PWD ContactList" extends "Contact List"
{
    layout
    {
        addafter("Search Name")
        {
            field("PWD Job Title"; "Job Title")
            {
                ApplicationArea = All;
            }
        }
    }
}

