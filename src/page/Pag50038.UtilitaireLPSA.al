page 50038 "PWD Utilitaire LPSA"
{
    Caption = 'Utilitaire LPSA';
    PageType = Card;
    ApplicationArea = all;
    UsageCategory = Tasks;

    actions
    {
        area(Processing)
        {
            action(Action1)
            {
                Caption = 'Item Extraction';
                RunObject = report "PWD Item Extraction";
                ApplicationArea = All;
                Image = AllocatedCapacity;
            }
            action(Action2)
            {
                Caption = 'TPL Ajout OP Lavage';
                RunObject = report "PWD TPL Ajout OP Lavage";
                ApplicationArea = All;
                Image = Add;
            }
            action(Action3)
            {
                Caption = 'TPL MAJ OP Gamme PIE';
                RunObject = report "PWD TPL MAJ OP Gamme PIE";
                ApplicationArea = All;
                Image = AllocatedCapacity;
            }
            action(Action4)
            {
                Caption = 'Ajout Nouvelle Fin De Gamme PIE';
                RunObject = report "PWD Ajout Nouv.Fin Gamme PIE";
                ApplicationArea = All;
                Image = Add;
            }
            action(Action5)
            {
                Caption = 'MAJ OP Gamme PIE Sans 1/2;B';
                RunObject = report "MAJ OP Gamme PIE Sans 1/2;B";
                ApplicationArea = All;
                Image = AllocatedCapacity;
            }
            action(Action6)
            {
                Caption = 'MAJ Description LPSA PIERRE';
                RunObject = report "MAJ Description LPSA PIERRE";
                ApplicationArea = All;
                Image = AllocatedCapacity;
            }
            action(Action7)
            {
                Caption = 'Suppression OP Gamme PIE';
                RunObject = report "PWD Suppression OP Gamme PIE";
                ApplicationArea = All;
                Image = Delete;
            }
            action(Action8)
            {
                Caption = 'MAJ Tps OP Gamme PIE';
                RunObject = report "PWD MAJ Tps OP Gamme PIE";
                ApplicationArea = All;
                Image = AllocatedCapacity;
            }
            action(Action9)
            {
                Caption = 'MAJ Tps OP Gamme PIE A/S O';
                RunObject = report "PWD MAJ Tps OP Gamme PIE A/S O";
                ApplicationArea = All;
                Image = AllocatedCapacity;
            }
            action(Action10)
            {
                Caption = 'Update Cost Method V2';
                RunObject = report "PWD Update Cost Method V2";
                ApplicationArea = All;
                Image = UpdateUnitCost;
            }
            action(Action11)
            {
                Caption = 'Inventory Recovery';
                RunObject = report "PWD Inventory Recovery";
                ApplicationArea = All;
                Image = AllocatedCapacity;
            }
            action(Action12)
            {
                Caption = 'Empty Buffer';
                RunObject = report "PWD Empty Buffer";
                ApplicationArea = All;
                Image = AllocatedCapacity;
            }
            action(Action13)
            {
                Caption = 'Modif OP après OP Gamme PIE';
                RunObject = report "Modif OP après OP Gamme PIE";
                ApplicationArea = All;
                Image = UpdateXML;
            }
        }
    }

}
