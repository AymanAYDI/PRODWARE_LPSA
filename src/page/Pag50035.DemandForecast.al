page 50035 "PWD Demand Forecast"
{
    ApplicationArea = Planning;
    Caption = 'Demand Forecast Overview (LPSA)';
    DataCaptionExpression = ProductionForecastName;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPlus;
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ProductionForecastName; ProductionForecastName)
                {
                    ApplicationArea = Planning;
                    Caption = 'Demand Forecast Name';
                    TableRelation = "Production Forecast Name".Name;

                    trigger OnValidate()
                    begin
                        SetMatrix();
                    end;
                }
                field(LocationFilter; LocationFilter)
                {
                    ApplicationArea = Planning;
                    Caption = 'Location Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Loc: Record Location;
                        LocList: Page "Location List";
                    begin
                        LocList.LookupMode(true);
                        Loc.SetRange("Use As In-Transit", false);
                        LocList.SetTableView(Loc);
                        if not (LocList.RunModal() = ACTION::LookupOK) then
                            exit(false);

                        Text := LocList.GetSelectionFilter();

                        exit(true);
                    end;

                    trigger OnValidate()
                    var
                        Location: Record Location;
                    begin
                        Location.SetFilter(Code, LocationFilter);
                        LocationFilter := Location.GetFilter(Code);
                        SetMatrix();
                    end;
                }
                field(PeriodType; PeriodType)
                {
                    ApplicationArea = Planning;
                    Caption = 'View by';

                    trigger OnValidate()
                    begin
                        SetMatrixColumns("Matrix Page Step Type"::Initial);

                        //>>TI464004
                        SetMatrix();
                        //<<TI464004s
                    end;
                }
                field(QtyType; QtyType)
                {
                    ApplicationArea = Planning;
                    Caption = 'View as';

                    trigger OnValidate()
                    begin
                        QtyTypeOnAfterValidate();
                    end;
                }
                field(ForecastType; ForecastType)
                {
                    ApplicationArea = Planning;
                    Caption = 'Forecast Type';

                    trigger OnValidate()
                    begin
                        ForecastTypeOnAfterValidate();
                    end;
                }
                field(DateFilter; DateFilter)
                {
                    ApplicationArea = Planning;
                    Caption = 'Date Filter';

                    trigger OnValidate()
                    var
                        FilterTokens: Codeunit "Filter Tokens";
                    begin
                        FilterTokens.MakeDateFilter(DateFilter);
                        SetMatrixColumns("Matrix Page Step Type"::Initial);
                        //>>TI464004
                        SetMatrix();
                        //<<TI464004s
                    end;
                }
                field("PWD CustomerFilter"; "CustomerFilter")
                {
                    Caption = 'Customer Filter';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Cust: Record Customer;
                        CustList: Page "Customer List";
                    begin
                        //>>LAP080615
                        CustList.LOOKUPMODE(TRUE);
                        Cust.FINDSET();
                        CustList.SETTABLEVIEW(Cust);
                        IF NOT (CustList.RUNMODAL() = ACTION::LookupOK) THEN
                            EXIT(FALSE)
                        ELSE
                            Text := CustList.GetSelectionFilter();
                        CustList.GETRECORD(Cust);
                        CustomerName := Cust.Name;
                        EXIT(TRUE);
                        //<<LAP080615
                    end;

                    trigger OnValidate()
                    begin
                        //>>LAP080615
                        SetMatrix();
                        //<<LAP080615
                    end;
                }
                field("PWD CustomerName"; "CustomerName")
                {
                    Caption = 'Customer Name';
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part(Matrix; "PWD Demand Forecast Matrix")
            {
                ApplicationArea = Planning;
                Caption = 'Demand Forecast Matrix';
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Copy Demand Forecast")
                {
                    ApplicationArea = Planning;
                    Caption = 'Copy Demand Forecast';
                    Ellipsis = true;
                    Image = CopyForecast;
                    RunObject = Report "Copy Production Forecast";
                }
            }
            action("Previous Set")
            {
                ApplicationArea = Planning;
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SetMatrixColumns("Matrix Page Step Type"::Previous);

                    //>>TI464004
                    SetMatrix();
                    //<<TI464004
                end;
            }
            action("Previous Column")
            {
                ApplicationArea = Planning;
                Caption = 'Previous Column';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SetMatrixColumns("Matrix Page Step Type"::PreviousColumn);

                    //>>TI464004
                    SetMatrix();
                    //<<TI464004
                end;
            }
            action("Next Column")
            {
                ApplicationArea = Planning;
                Caption = 'Next Column';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SetMatrixColumns("Matrix Page Step Type"::NextColumn);

                    //>>TI464004
                    SetMatrix();
                    //<<TI464004
                end;
            }
            action("Next Set")
            {
                ApplicationArea = Planning;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SetMatrixColumns("Matrix Page Step Type"::Next);

                    //>>TI464004
                    SetMatrix();
                    //<<TI464004
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if (NewProductionForecastName <> '') and (NewProductionForecastName <> ProductionForecastName) then
            ProductionForecastName := NewProductionForecastName;
        SetMatrixColumns("Matrix Page Step Type"::Initial);
    end;

    var
        MatrixRecords: array[32] of Record Date;
        PeriodType: Enum "Analysis Period Type";
        QtyType: Enum "Analysis Amount Type";
        ForecastType: Enum "Demand Forecast Type";
        ProductionForecastName: Text[30];
        NewProductionForecastName: Text[30];
        LocationFilter: Text;
        DateFilter: Text[1024];
        MatrixColumnCaptions: array[32] of Text[1024];
        ColumnSet: Text[1024];
        PKFirstRecInCurrSet: Text[100];
        CurrSetLength: Integer;
        CustomerFilter: Text[30];
        CustomerName: Text[100];

    procedure SetMatrixColumns(StepType: Enum "Matrix Page Step Type")
    var
        MatrixMgt: Codeunit "Matrix Management";
    begin
        //        IF (LocationFilter <> '') AND (CustomerFilter <> '') THEN
        MatrixMgt.GeneratePeriodMatrixData(
            StepType.AsInteger(), ArrayLen(MatrixRecords), false, PeriodType, DateFilter, PKFirstRecInCurrSet,
            MatrixColumnCaptions, ColumnSet, CurrSetLength, MatrixRecords);
        //>>TI464004
        //SetMatrix;
        //<<TI464004s
    end;

    procedure SetProductionForecastName(NextProductionForecastName: Text[30])
    begin
        NewProductionForecastName := NextProductionForecastName;
    end;

    procedure SetMatrix()
    begin
        CurrPage.Matrix.PAGE.LoadMatrix(
          MatrixColumnCaptions, MatrixRecords, ProductionForecastName, DateFilter, LocationFilter, ForecastType,
          QtyType, CurrSetLength, CustomerFilter);
        CurrPage.Update(false);
    end;

    local procedure ForecastTypeOnAfterValidate()
    begin
        SetMatrix();
    end;

    local procedure QtyTypeOnAfterValidate()
    begin
        SetMatrix();
    end;
}

