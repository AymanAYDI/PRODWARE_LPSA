page 50020 "PWD Routing Lines choice"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // TDL.LPSA.001 19/06/2015 :           Page Creation (used in Report 50075)
    // ------------------------------------------------------------------------------------------------------------------

    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Routing Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Operation No."; "Operation No.")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                }
                field("Previous Operation No."; "Previous Operation No.")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                }
                field("Next Operation No."; "Next Operation No.")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                }
                field(Type; Type)
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                }
                field("No."; "No.")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                }
                field("Standard Task Code"; "Standard Task Code")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                }
                field("Routing Link Code"; "Routing Link Code")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                }
                field(Description; Description)
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                }
                field("Setup Time"; "Setup Time")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                }
                field("Setup Time Unit of Meas. Code"; "Setup Time Unit of Meas. Code")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                }
                field("Run Time"; "Run Time")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                }
                field("Run Time Unit of Meas. Code"; "Run Time Unit of Meas. Code")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                }
                field("Wait Time"; "Wait Time")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                }
                field("Wait Time Unit of Meas. Code"; "Wait Time Unit of Meas. Code")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                }
                field("Move Time"; "Move Time")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                }
                field("Move Time Unit of Meas. Code"; "Move Time Unit of Meas. Code")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                }
                field("Fixed Scrap Quantity"; "Fixed Scrap Quantity")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                }
                field("Scrap Factor %"; "Scrap Factor %")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                }
                field("Minimum Process Time"; "Minimum Process Time")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                }
                field("Maximum Process Time"; "Maximum Process Time")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                }
                field("Concurrent Capacities"; "Concurrent Capacities")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                }
                field("Send-Ahead Quantity"; "Send-Ahead Quantity")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                }
                field("Unit Cost per"; "Unit Cost per")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                }
                field("Next Operation Link Type"; "Next Operation Link Type")
                {
                }
                field("Fixed-step Prod. Rate time"; "Fixed-step Prod. Rate time")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        BooGStyle := (Type = Type::"Machine Center");
    end;

    var
        RtngComment: Record "Routing Comment Line";
        [InDataSet]
        BooGStyle: Boolean;


    procedure SetSelection(var RL: Record "Routing Line")
    begin
        CurrPage.SETSELECTIONFILTER(RL);
    end;


    procedure GetSelectionFilter(): Code[80]
    var
        RL: Record "Routing Line";
        FirstRL: Text[20];
        LastRL: Text[20];
        SelectionFilter: Code[80];
        RLCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(RL);
        //RL.SETCURRENTKEY("No.");
        RLCount := RL.COUNT;
        IF RLCount > 0 THEN BEGIN
            RL.FIND('-');
            WHILE RLCount > 0 DO BEGIN
                RLCount := RLCount - 1;
                RL.MARKEDONLY(FALSE);
                FirstRL := RL."Operation No.";
                LastRL := FirstRL;
                More := (RLCount > 0);
                WHILE More DO
                    IF RL.NEXT = 0 THEN
                        More := FALSE
                    ELSE
                        IF NOT RL.MARK THEN
                            More := FALSE
                        ELSE BEGIN
                            LastRL := RL."Operation No.";
                            RLCount := RLCount - 1;
                            IF RLCount = 0 THEN
                                More := FALSE;
                        END;
                IF SelectionFilter <> '' THEN
                    SelectionFilter := SelectionFilter + '|';
                IF FirstRL = LastRL THEN
                    SelectionFilter := SelectionFilter + FirstRL
                ELSE
                    SelectionFilter := SelectionFilter + FirstRL + '..' + LastRL;
                IF RLCount > 0 THEN BEGIN
                    RL.MARKEDONLY(TRUE);
                    RL.NEXT;
                END;
            END;
        END;
        EXIT(SelectionFilter);
    end;
}

