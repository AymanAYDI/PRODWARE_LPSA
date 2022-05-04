dotnet
{
    assembly("Prodware.Dynamics.Nav.ProdConnect")
    {
        Version = '2.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = '4d78b8ca6f343f8c';

        type("Prodware.Dynamics.Nav.ProdConnect.FileManagement"; "PWD FileManagement")
        {
        }
    }
    //TODO:An assembly named 'Microsoft.Office.Interop.Excel, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c' could not be found
    // assembly("Microsoft.Office.Interop.Excel")
    // {
    //     Version = '15.0.0.0';
    //     Culture = 'neutral';
    //     PublicKeyToken = '71e9bce111e9429c';
    //     type("Microsoft.Office.Interop.Excel.ApplicationClass"; "EXCEL ApplicationClass")
    //     {
    //     }

    //     type("Microsoft.Office.Interop.Excel.Workbook"; "EXCEL Workbook")
    //     {
    //     }

    //     type("Microsoft.Office.Interop.Excel.Worksheet"; "EXCEL Worksheet")
    //     {
    //     }
    //     type("Microsoft.Office.Interop.Excel.Range"; "EXCEL Range")
    //     {
    //     }
    // }
}