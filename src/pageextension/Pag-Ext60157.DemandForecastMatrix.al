// pageextension 60157 "PWD DemandForecastMatrix" extends "Demand Forecast Matrix"
// {
//     trigger OnModifyRecord(): Boolean
//     Var
//         LPSASetGetFunctions: Codeunit "PWD LPSA Set/Get Functions.";
//         TxtL001: Label 'Refresh Item List for Customer...';
//         Window: Dialog;
//     begin
//         Rec.CLEARMARKS();
//         IF LPSASetGetFunctions.GetCustomerFilter() <> '' THEN BEGIN
//             Rec.SETFILTER("PWD Customer Filter", LPSASetGetFunctions.GetCustomerFilter());
//             Rec.CALCFIELDS("PWD ToForecast");
//             Rec.SETRANGE("PWD ToForecast", TRUE);
//         END
//         ELSE BEGIN
//             Rec.SETRANGE("PWD Customer Filter");
//             Rec.SETRANGE("PWD ToForecast");
//         END;
//         //FILTERGROUP(0);
//         Window.OPEN(TxtL001);
//         CurrPage.UPDATE(FALSE);
//         Window.CLOSE;
//         //<<LAP080615
//     end;
// }