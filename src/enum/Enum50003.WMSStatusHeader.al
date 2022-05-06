enum 50003 "PWD WMS_Status_Header"
{
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Released)
    {
        Caption = 'Released';
    }
    value(2; "Pending Approval")
    {
        Caption = 'Pending Approval';
    }
    value(3; "Pending Prepayment")
    {
        Caption = 'Pending Prepayment';
    }
}
