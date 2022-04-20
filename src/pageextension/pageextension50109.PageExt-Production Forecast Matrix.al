pageextension 50109 pageextension50109 extends "Production Forecast Matrix"
{
    // 
    // //>>LAP080615
    // TO 06/06/2015 : Customer Filter
    //                 -Add C/AL
    // 
    // //>>LAP181016
    // RO 18/10/2016 : Modif C/AL Code in trigger Enter_BaseQty

    var
        CustomerFilter: Code[20];
        Text005: Label 'You must set a customer filter.';

        //Unsupported feature: Parameter Insertion (Parameter: CustomerFilter1) (ParameterCollection) on "Load(PROCEDURE 1098)".


        //Unsupported feature: Variable Insertion (Variable: RecLCrossRef) (VariableCollection) on "Load(PROCEDURE 1098)".


        //Unsupported feature: Variable Insertion (Variable: Window) (VariableCollection) on "Load(PROCEDURE 1098)".


        //Unsupported feature: Variable Insertion (Variable: TxtL001) (VariableCollection) on "Load(PROCEDURE 1098)".



        //Unsupported feature: Code Modification on "Load(PROCEDURE 1098)".

        //procedure Load();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        COPYARRAY(MATRIX_CaptionSet,MatrixColumns1,1);
        FOR i := 1 TO ARRAYLEN(MatrixRecords) DO BEGIN
          IF MatrixColumns1[i] = '' THEN
        #4..9
        ProductionForecastName := ProductionForecastName1;
        DateFilter := DateFilter1;
        LocationFilter := LocationFilter1;
        ForecastType := ForecastType1;
        QtyType := QtyType1;
        MATRIX_NoOfMatrixColumns := NoOfMatrixColumns1;

        IF ForecastType = ForecastType::Component THEN
          SETRANGE("Component Forecast",TRUE);
        IF ForecastType = ForecastType::"Sales Item" THEN
          SETRANGE("Component Forecast",FALSE);
        IF ForecastType = ForecastType::Both THEN
          SETRANGE("Component Forecast");

        SetVisible;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //>>LAP080615 Add parameter CustomerFilter
        CLEARMARKS;

        #1..12
        //>>LAP080615
        CustomerFilter:=CustomerFilter1;
        //<<LAP080615
        #13..15
        #17..24

        //>>LAP080615
        //FILTERGROUP(2);
        IF CustomerFilter<>'' THEN
        BEGIN
          SETFILTER("Customer Filter", CustomerFilter);
          CALCFIELDS(ToForecast);
          SETRANGE(ToForecast,TRUE);
        END
        ELSE
        BEGIN
          SETRANGE("Customer Filter");
          SETRANGE(ToForecast);
        END;
        //FILTERGROUP(0);

        Window.OPEN(TxtL001);
        CurrPage.UPDATE(FALSE);
        Window.CLOSE;
        //<<LAP080615
        */
        //end;


        //Unsupported feature: Code Modification on "MatrixOnDrillDown(PROCEDURE 1099)".

        //procedure MatrixOnDrillDown();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        SetDateFilter(ColumnID);
        ProductionForecastEntry.SETCURRENTKEY("Production Forecast Name","Item No.","Location Code","Forecast Date","Component Forecast");
        ProductionForecastEntry.SETRANGE("Item No.","No.");
        #4..12
          ProductionForecastEntry.SETFILTER("Location Code",LocationFilter)
        ELSE
          ProductionForecastEntry.SETRANGE("Location Code");
        ProductionForecastEntry.SETFILTER("Component Forecast",GETFILTER("Component Forecast"));
        FORM.RUN(0,ProductionForecastEntry);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..15
        //>>LAP080615
        IF CustomerFilter <> '' THEN
          ProductionForecastEntry.SETFILTER("Customer No.",CustomerFilter)
        ELSE
          ProductionForecastEntry.SETRANGE("Customer No.");
        //<<LAP080615
        ProductionForecastEntry.SETFILTER("Component Forecast",GETFILTER("Component Forecast"));
        FORM.RUN(0,ProductionForecastEntry);
        */
        //end;


        //Unsupported feature: Code Modification on ""MATRIX_OnAfterGetRecord"(PROCEDURE 1102)".

        //procedure "MATRIX_OnAfterGetRecord"();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        SetDateFilter(ColumnOrdinal);
        IF ProductionForecastName <> '' THEN
          SETRANGE("Production Forecast Name",ProductionForecastName)
        #4..7
        ELSE
          SETRANGE("Location Filter");

        IF ForecastType = ForecastType::Component THEN
          SETRANGE("Component Forecast",TRUE);
        IF ForecastType = ForecastType::"Sales Item" THEN
        #14..16

        CALCFIELDS("Prod. Forecast Quantity (Base)");
        MATRIX_CellData[ColumnOrdinal] := "Prod. Forecast Quantity (Base)";
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..10
        //>>LAP080615
        IF CustomerFilter<>'' THEN
          SETFILTER("Customer Filter",CustomerFilter)
        ELSE
          SETRANGE("Customer Filter");
        //<<LAP080615

        #11..19
        */
        //end;


        //Unsupported feature: Code Modification on "QtyValidate(PROCEDURE 1102601000)".

        //procedure QtyValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        Enter_BaseQty(ColumnID);
        ProdForecastQtyBase_OnValidate(ColumnID);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        Enter_BaseQty(ColumnID);
        ProdForecastQtyBase_OnValidate(ColumnID);
        //>>LAP080615
        CurrPage.UPDATE(TRUE);
        //<<LAP080615
        */
        //end;


        //Unsupported feature: Code Modification on ""Enter_BaseQty"(PROCEDURE 2)".

        //procedure "Enter_BaseQty"();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        SetDateFilter(ColumnID);
        IF QtyType = QtyType::"Net Change" THEN
          SETRANGE("Date Filter",MatrixRecords[ColumnID]."Period Start",MatrixRecords[ColumnID]."Period End")
        #4..11
        ELSE
          SETRANGE("Location Filter");

        IF ForecastType = ForecastType::Component THEN
          SETRANGE("Component Forecast",TRUE);
        IF ForecastType = ForecastType::"Sales Item" THEN
          SETRANGE("Component Forecast",FALSE);
        IF ForecastType = ForecastType::Both THEN
          SETRANGE("Component Forecast");
        VALIDATE("Prod. Forecast Quantity (Base)",MATRIX_CellData[ColumnID]);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..14
        //>>LAP080615
        IF CustomerFilter<>'' THEN
          SETFILTER("Customer Filter",CustomerFilter)
        ELSE
          SETRANGE("Customer Filter");
        //<<LAP080615

        #15..20

        //>>LAP181016
        SETRANGE("Date Filter",MatrixRecords[ColumnID]."Period End");
        //<<LAP181016

        VALIDATE("Prod. Forecast Quantity (Base)",MATRIX_CellData[ColumnID]);

        //>>LAP181016
        IF QtyType = QtyType::"Net Change" THEN
          SETRANGE("Date Filter",MatrixRecords[ColumnID]."Period Start",MatrixRecords[ColumnID]."Period End")
        ELSE
          SETRANGE("Date Filter",0D,MatrixRecords[ColumnID]."Period End");
        //<<LAP181016
        */
        //end;

        //Unsupported feature: Variable Insertion (Variable: CustomerNo) (VariableCollection) on ""ProdForecastQtyBase_OnValidate"(PROCEDURE 4)".



        //Unsupported feature: Code Modification on ""ProdForecastQtyBase_OnValidate"(PROCEDURE 4)".

        //procedure "ProdForecastQtyBase_OnValidate"();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF ForecastType = ForecastType::Both THEN
          ERROR(Text000);
        ProdForecastEntry.SETCURRENTKEY("Production Forecast Name","Item No.","Location Code","Forecast Date","Component Forecast");
        ProdForecastEntry.SETRANGE("Production Forecast Name",GETFILTER("Production Forecast Name"));
        ProdForecastEntry.SETRANGE("Item No.","No.");
        ProdForecastEntry.SETRANGE("Location Code",GETFILTER("Location Filter"));
        ProdForecastEntry.SETRANGE(
          "Forecast Date",
          MatrixRecords[ColumnID]."Period Start",
          MatrixRecords[ColumnID]."Period End");
        ProdForecastEntry.SETFILTER("Component Forecast", GETFILTER("Component Forecast"));
        IF ProdForecastEntry.FIND('+') THEN
          IF ProdForecastEntry."Forecast Date" > MatrixRecords[ColumnID]."Period Start" THEN
            IF CONFIRM(
        #15..20
               ProdForecastEntry.MODIFYALL("Forecast Date",MatrixRecords[ColumnID]."Period Start")
             ELSE
               ERROR(Text004);
        ProdForecastEntry2.SETCURRENTKEY(
          "Production Forecast Name","Item No.","Location Code","Forecast Date","Component Forecast");
        IF GETFILTER("Location Filter") = '' THEN BEGIN
        #27..32
              ERROR(Text003);
          END;
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..6

        //>>LAP080615
        ProdForecastEntry.SETRANGE("Customer No.",GETFILTER("Customer Filter"));
        //<<LAP080615

        #7..11


        //>>LAP080615: change Forecast Date to nonworking date
        {
        #12..23
        }
        //<<LAP080615

        #24..35

        //>>LAP080615
        IF GETFILTER("Customer Filter") = '' THEN BEGIN
          ProdForecastEntry2.COPYFILTERS(ProdForecastEntry);
          ProdForecastEntry2.SETRANGE("Customer No.");
          IF ProdForecastEntry2.FIND('-') THEN BEGIN
            CustomerNo := ProdForecastEntry2."Customer No.";
            ProdForecastEntry2.FIND('+');
            IF ProdForecastEntry2."Customer No." <> CustomerNo THEN
              ERROR(Text005);
          END;
        END;
        //<<LAP080615
        */
        //end;
}

