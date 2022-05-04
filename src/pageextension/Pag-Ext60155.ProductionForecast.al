// //TODO:The target Page "Production Forecast" for the extension object is not found
// pageextension 60155 "PWD ProductionForecast" extends "Production Forecast"
// {
//     // //>>LAP080615
//     // TO 06/06/2015 : Customer Filter
//     //                 -Add C/AL
//     // 
//     // //>>MODIF HL
//     // TI464004 DO.GEPO 03/07/2019 : modify fct SetColumns
//     layout
//     {


//         //Unsupported feature: Code Modification on "Control 18.OnValidate".

//         //trigger OnValidate()
//         //Parameters and return type have not been exported.
//         //>>>> ORIGINAL CODE:
//         //begin
//         /*
//         SetColumns(SetWanted::First);
//         */
//         //end;
//         //>>>> MODIFIED CODE:
//         //begin
//         /*
//         SetColumns(SetWanted::First);
//         //>>TI464004
//         SetMatrix;
//         //<<TI464004
//         */
//         //end;


//         //Unsupported feature: Code Modification on "Control 21.OnValidate".

//         //trigger OnValidate()
//         //Parameters and return type have not been exported.
//         //>>>> ORIGINAL CODE:
//         //begin
//         /*
//         IF ApplicationManagement.MakeDateFilter(DateFilter) = 0 THEN;
//         SetColumns(SetWanted::First);
//         */
//         //end;
//         //>>>> MODIFIED CODE:
//         //begin
//         /*
//         IF ApplicationManagement.MakeDateFilter(DateFilter) = 0 THEN;
//         SetColumns(SetWanted::First);
//         //>>TI464004
//         SetMatrix;
//         //<<TI464004
//         */
//         //end;
//         addafter("Control 21")
//         {
//             field("PWD CustomerFilter"; CustomerFilter)
//             {
//                 Caption = 'Customer Filter';
//                 ApplicationArea = All;

//                 trigger OnLookup(var Text: Text): Boolean
//                 var
//                     Cust: Record 18;
//                     CustList: Page 22;
//                 begin
//                     //>>LAP080615
//                     CustList.LOOKUPMODE(TRUE);
//                     Cust.FINDSET();
//                     CustList.SETTABLEVIEW(Cust);
//                     IF NOT (CustList.RUNMODAL() = ACTION::LookupOK) THEN
//                         EXIT(FALSE)
//                     ELSE
//                         Text := CustList.GetSelectionFilter();
//                     CustList.GETRECORD(Cust);
//                     CustomerName := Cust.Name;
//                     EXIT(TRUE);
//                     //<<LAP080615
//                 end;

//                 trigger OnValidate()
//                 begin
//                     //>>LAP080615
//                     SetMatrix;
//                     //<<LAP080615
//                 end;
//             }
//             field("PWD CustomerName"; CustomerName)
//             {
//                 Caption = 'Customer Name';
//                 Editable = false;
//                 ApplicationArea = All;
//             }
//         }
//     }
//     actions
//     {


//         //Unsupported feature: Code Modification on "Action 25.OnAction".

//         //trigger OnAction()
//         //Parameters and return type have not been exported.
//         //>>>> ORIGINAL CODE:
//         //begin
//         /*
//         SetColumns(SetWanted::Previous);
//         */
//         //end;
//         //>>>> MODIFIED CODE:
//         //begin
//         /*
//         SetColumns(SetWanted::Previous);
//         //>>TI464004
//         SetMatrix;
//         //<<TI464004
//         */
//         //end;


//         //Unsupported feature: Code Modification on "Action 24.OnAction".

//         //trigger OnAction()
//         //Parameters and return type have not been exported.
//         //>>>> ORIGINAL CODE:
//         //begin
//         /*
//         SetColumns(SetWanted::PreviousColumn);
//         */
//         //end;
//         //>>>> MODIFIED CODE:
//         //begin
//         /*
//         SetColumns(SetWanted::PreviousColumn);
//         //>>TI464004
//         SetMatrix;
//         //<<TI464004
//         */
//         //end;


//         //Unsupported feature: Code Modification on "Action 23.OnAction".

//         //trigger OnAction()
//         //Parameters and return type have not been exported.
//         //>>>> ORIGINAL CODE:
//         //begin
//         /*
//         SetColumns(SetWanted::NextColumn);
//         */
//         //end;
//         //>>>> MODIFIED CODE:
//         //begin
//         /*
//         SetColumns(SetWanted::NextColumn);
//         //>>TI464004
//         SetMatrix;
//         //<<TI464004
//         */
//         //end;


//         //Unsupported feature: Code Modification on "Action 22.OnAction".

//         //trigger OnAction()
//         //Parameters and return type have not been exported.
//         //>>>> ORIGINAL CODE:
//         //begin
//         /*
//         SetColumns(SetWanted::Next);
//         */
//         //end;
//         //>>>> MODIFIED CODE:
//         //begin
//         /*
//         SetColumns(SetWanted::Next);
//         //>>TI464004
//         SetMatrix;
//         //<<TI464004
//         */
//         //end;
//     }

//     var
//         CustomerFilter: Text[30];
//         CustomerName: Text[50];


//     //Unsupported feature: Code Modification on "OnOpenPage".

//     //trigger OnOpenPage()
//     //>>>> ORIGINAL CODE:
//     //begin
//     /*
//     IF (NewProductionForecastName <> '') AND (NewProductionForecastName <> ProductionForecastName) THEN
//       ProductionForecastName := NewProductionForecastName;
//     SetColumns(SetWanted::First);
//     */
//     //end;
//     //>>>> MODIFIED CODE:
//     //begin
//     /*
//     #1..3
//     CustomerName:='';
//     */
//     //end;


//     //Unsupported feature: Code Modification on "SetColumns(PROCEDURE 6)".

//     //procedure SetColumns();
//     //Parameters and return type have not been exported.
//     //>>>> ORIGINAL CODE:
//     //begin
//     /*
//     MatrixMgt.GeneratePeriodMatrixData(SetWanted,ARRAYLEN(MatrixRecords),FALSE,PeriodType,DateFilter,PKFirstRecInCurrSet,
//       MatrixColumnCaptions,ColumnSet,CurrSetLength,MatrixRecords);
//     SetMatrix;
//     */
//     //end;
//     //>>>> MODIFIED CODE:
//     //begin
//     /*
//     MatrixMgt.GeneratePeriodMatrixData(SetWanted,ARRAYLEN(MatrixRecords),FALSE,PeriodType,DateFilter,PKFirstRecInCurrSet,
//       MatrixColumnCaptions,ColumnSet,CurrSetLength,MatrixRecords);
//     //>>TI464004
//     //SetMatrix;
//     //<<TI464004
//     */
//     //end;


//     //Unsupported feature: Code Modification on "SetMatrix(PROCEDURE 1102601000)".

//     //procedure SetMatrix();
//     //Parameters and return type have not been exported.
//     //>>>> ORIGINAL CODE:
//     //begin
//     /*
//     CurrPage.Matrix.FORM.
//     Load(MatrixColumnCaptions,MatrixRecords,ProductionForecastName,DateFilter,LocationFilter,ForecastType,QtyType
//       ,CurrSetLength);
//     */
//     //end;
//     //>>>> MODIFIED CODE:
//     //begin
//     /*
//     IF (LocationFilter <> '') AND (CustomerFilter <> '' ) THEN
//     BEGIN
//     CurrPage.Matrix.PAGE.
//     Load(MatrixColumnCaptions,MatrixRecords,ProductionForecastName,DateFilter,LocationFilter,ForecastType,QtyType
//     //>>LAP080615
//     //  ,CurrSetLength);
//       ,CurrSetLength,CustomerFilter);
//     //<<LAP080615
//     END;
//     */
//     //end;
// }

