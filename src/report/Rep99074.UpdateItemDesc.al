report 99074 "PWD Update Item Desc"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/UpdateItemDesc.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = WHERE("Location Code" = CONST('PIE'));

            trigger OnAfterGetRecord()
            var
                Pos: Integer;
                Len: Integer;
            begin
                Pos := 0;
                Len := 0;
                Pos := StrPos("PWD LPSA Description 1", '-');
                Len := StrLen("PWD LPSA Description 1");
                if Pos <> 0 then begin
                    Txt := CopyStr("PWD LPSA Description 1", Pos + 1, Len);
                    Txt := CopyStr(Txt, 1, 40);
                    "PWD Quartis Description" := Txt;
                    Modify();
                end;
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

    var
        Txt: Text[120];
}

