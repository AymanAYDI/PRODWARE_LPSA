page 50037 "PWD Import STOCK"
{
    Caption = 'Import stock';
    PageType = Card;
    ApplicationArea = all;
    UsageCategory = Tasks;
    actions
    {
        area(Processing)
        {
            action(Action1)
            {
                Caption = 'Import stock';
                RunObject = XMLport "PWD Import STOCK";
                ApplicationArea = All;
                Image = NonStockItem;
            }
        }
    }
}