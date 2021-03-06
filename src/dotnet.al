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
    assembly("Prodware.Dynamics.Nav.FTP")
    {
        Version = '1.0.1.0';
        Culture = 'neutral';
        PublicKeyToken = 'dfcb462dc2b30afd';

        type("Prodware.Dynamics.Nav.FTP.CFtp"; "PWD CFtp")
        {
        }
    }
    assembly("Microsoft.Office.Interop.Excel")
    {
        Version = '15.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = '71e9bce111e9429c';
        type("Microsoft.Office.Interop.Excel.ApplicationClass"; "EXCEL ApplicationClass")
        {
        }

        type("Microsoft.Office.Interop.Excel.Workbook"; "EXCEL Workbook")
        {
        }
        type("Microsoft.Office.Interop.Excel.Worksheet"; "EXCEL Worksheet")
        {
        }
        type("Microsoft.Office.Interop.Excel.Range"; "EXCEL Range")
        {
        }
    }
    assembly(Prodware.Dynamics.Nav.PrintPDF)
    {
        type("Prodware.Dynamics.Nav.PrintPDF.PrintPDF"; "PWD PrintPDF")
        {
        }
    }
}