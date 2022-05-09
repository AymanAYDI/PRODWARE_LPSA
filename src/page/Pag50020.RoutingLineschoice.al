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
    UsageCategory = none;
    SourceTable = "Routing Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Operation No."; Rec."Operation No.")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    ApplicationArea = All;
                }
                field("Previous Operation No."; Rec."Previous Operation No.")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Next Operation No."; Rec."Next Operation No.")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    ApplicationArea = All;
                }
                field("Standard Task Code"; Rec."Standard Task Code")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Routing Link Code"; Rec."Routing Link Code")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    ApplicationArea = All;
                }
                field("Setup Time"; Rec."Setup Time")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    ApplicationArea = All;
                }
                field("Setup Time Unit of Meas. Code"; Rec."Setup Time Unit of Meas. Code")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Run Time"; Rec."Run Time")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    ApplicationArea = All;
                }
                field("Run Time Unit of Meas. Code"; Rec."Run Time Unit of Meas. Code")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Wait Time"; Rec."Wait Time")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    ApplicationArea = All;
                }
                field("Wait Time Unit of Meas. Code"; Rec."Wait Time Unit of Meas. Code")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Move Time"; Rec."Move Time")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    ApplicationArea = All;
                }
                field("Move Time Unit of Meas. Code"; Rec."Move Time Unit of Meas. Code")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Fixed Scrap Quantity"; Rec."Fixed Scrap Quantity")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    ApplicationArea = All;
                }
                field("Scrap Factor %"; Rec."Scrap Factor %")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    ApplicationArea = All;
                }
                field("Minimum Process Time"; Rec."Minimum Process Time")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Maximum Process Time"; Rec."Maximum Process Time")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Concurrent Capacities"; Rec."Concurrent Capacities")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    ApplicationArea = All;
                }
                field("Send-Ahead Quantity"; Rec."Send-Ahead Quantity")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    ApplicationArea = All;
                }
                field("Unit Cost per"; Rec."Unit Cost per")
                {
                    Style = StandardAccent;
                    StyleExpr = BooGStyle;
                    ApplicationArea = All;
                }
                //TODO: l'extension de la table "Routing Line" n'existe pas qui contient les 2 champs "Next Operation Link Type","Fixed-step Prod. Rate time"
                // field("Next Operation Link Type"; Rec."Next Operation Link Type")
                // {
                //     ApplicationArea = All;
                // }
                // field("Fixed-step Prod. Rate time"; Rec."Fixed-step Prod. Rate time")
                // {
                //     Style = StandardAccent;
                //     StyleExpr = BooGStyle;
                //     ApplicationArea = All;
                // }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        BooGStyle := (Rec.Type = Rec.Type::"Machine Center");
    end;

    var
        [InDataSet]
        BooGStyle: Boolean;


    procedure SetSelection(var RL: Record "Routing Line")
    begin
        CurrPage.SETSELECTIONFILTER(RL);
    end;


    procedure GetSelectionFilter(): Code[80]
    var
        RL: Record "Routing Line";
        More: Boolean;
        SelectionFilter: Code[80];
        RLCount: Integer;
        FirstRL: Text[20];
        LastRL: Text[20];
    begin
        CurrPage.SETSELECTIONFILTER(RL);
        //RL.SETCURRENTKEY("No.");
        RLCount := RL.COUNT;
        IF RLCount > 0 THEN BEGIN
            SelectionFilter := '';
            RL.FIND('-');
            WHILE RLCount > 0 DO BEGIN
                RLCount := RLCount - 1;
                RL.MARKEDONLY(FALSE);
                FirstRL := RL."Operation No.";
                LastRL := FirstRL;
                More := (RLCount > 0);
                WHILE More DO
                    IF RL.NEXT() = 0 THEN
                        More := FALSE
                    ELSE
                        IF NOT RL.MARK() THEN
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
                    RL.NEXT();
                END;
            END;
        END;
        EXIT(SelectionFilter);
    end;
}

