enum 50008 "PWD Status Buffer"
{
    Extensible = true;
    
    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Inserted)
    {
        Caption = 'Inserted';
    }
    value(2; Modified)
    {
        Caption = 'Modified';
    }
    value(3; Deleted)
    {
        Caption = 'Deleted';
    }
}
