report 50078 "PWD Update Check Lines"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateCheckLines.rdl';
    UsageCategory = none;
    dataset
    {
        dataitem("Routing Line"; "Routing Line")
        {
            DataItemTableView = WHERE("Routing No." = CONST('TT_OPE_PIE'));
            column(Routing_Line_Description; Description)
            {
            }
            column(Routing_Line__Work_Center_Group_Code_; "Work Center Group Code")
            {
            }
            column(Routing_Line__Work_Center_No__; "Work Center No.")
            {
            }
            column(Routing_Line__No__; "No.")
            {
            }
            column(Routing_Line_Type; Type)
            {
            }
            column(Routing_Line__Previous_Operation_No__; "Previous Operation No.")
            {
            }
            column(Routing_Line__Next_Operation_No__; "Next Operation No.")
            {
            }
            column(Routing_Line__Operation_No__; "Operation No.")
            {
            }
            column(Routing_Line__Routing_No__; "Routing No.")
            {
            }
            column(Routing_Line_DescriptionCaption; FieldCaption(Description))
            {
            }
            column(Routing_Line__Work_Center_Group_Code_Caption; FieldCaption("Work Center Group Code"))
            {
            }
            column(Routing_Line__Work_Center_No__Caption; FieldCaption("Work Center No."))
            {
            }
            column(Routing_Line__No__Caption; FieldCaption("No."))
            {
            }
            column(Routing_Line_TypeCaption; FieldCaption(Type))
            {
            }
            column(Routing_Line__Previous_Operation_No__Caption; FieldCaption("Previous Operation No."))
            {
            }
            column(Routing_Line__Next_Operation_No__Caption; FieldCaption("Next Operation No."))
            {
            }
            column(Routing_Line__Operation_No__Caption; FieldCaption("Operation No."))
            {
            }
            column(Routing_Line__Routing_No__Caption; FieldCaption("Routing No."))
            {
            }
            column(Routing_Line_Version_Code; "Version Code")
            {
            }

            trigger OnAfterGetRecord()
            var
                RecLRoutingLineOF: Record "Prod. Order Routing Line";
                BooLOK: Boolean;
            begin
                RecLRoutingLineOF.SetFilter(RecLRoutingLineOF.Status, '<%1', RecLRoutingLineOF.Status::Finished);
                RecLRoutingLineOF.SetFilter("Routing Status", '<%1', RecLRoutingLineOF."Routing Status"::Finished);
                RecLRoutingLineOF.SetRange(Type, "Routing Line".Type);
                RecLRoutingLineOF.SetRange("Operation No.", "Operation No.");
                RecLRoutingLineOF.SetRange("No.", "No.");
                RecLRoutingLineOF.SetFilter("Run Time", '<>%1', "Run Time");
                if not RecLRoutingLineOF.FindFirst() then
                    BooLOK := true
                else
                    BooLOK := false;

                RecLRoutingLineOF.SetRange("Run Time");
                RecLRoutingLineOF.SetFilter("Move Time", '<>%1', "Move Time");
                if RecLRoutingLineOF.IsEmpty then
                    BooLOK := true
                else
                    BooLOK := false;

                if BooLOK then
                    CurrReport.Skip();
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
}

