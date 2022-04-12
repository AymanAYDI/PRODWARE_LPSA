report 99091 "PWD tmp art pierres"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/tmpartpierres.rdl';

    dataset
    {
        dataitem(Item; Item)
        {

            trigger OnAfterGetRecord()
            begin

                TxtGTest := CopyStr(Item."No.", 1, 4);
                case TxtGTest of
                    '5121':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'GRAND');
                            Modify;
                        end;
                    '5131':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'TOURN_1');
                            Modify;
                        end;
                    '5141':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'CREUS');
                            Modify;
                        end;
                    '5151':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'OLIV');
                            Modify;
                        end;
                    '5161':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'POLI_2');
                            Modify;
                        end;
                    '5171':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'POLI_1');
                            Modify;
                        end;
                    '8020':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'PIE');
                            Modify;
                        end;
                    '8030':
                        begin
                            Validate("Location Code", 'LEV_ELIPS');
                            Validate("Shelf No.", 'LEV_ELIPS');
                            Modify;
                        end;
                    '8040':
                        begin
                            Validate("Location Code", 'LEV_ELIPS');
                            Validate("Shelf No.", 'LEV_ELIPS');
                            Modify;
                        end;
                    '9901':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'CP');
                            Modify;
                        end;
                    '9902':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'PREP');
                            Modify;
                        end;
                    '9903':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'BAR_TUB');
                            Modify;
                        end;
                    '9904':
                        begin
                            Validate("Location Code", 'LEV_ELIPS');
                            Validate("Shelf No.", 'CARRELET');
                            Modify;
                        end;
                    '9905':
                        begin
                            Validate("Location Code", 'LEV_ELIPS');
                            Validate("Shelf No.", 'CHEV');
                            Modify;
                        end;
                    '9906':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'GOUP');
                            Modify;
                        end;
                    '9911':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'PERC_LASER');
                            Modify;
                        end;
                    '9912':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'PERC_BROCH');
                            Modify;
                        end;
                    '9913':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'P_FIL');
                            Modify;
                        end;
                    '9914':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'BAR_TUB');
                            Modify;
                        end;
                    '9920':
                        begin
                            Validate("Location Code", 'PIE');
                            Validate("Shelf No.", 'PIE');
                            Modify;
                        end;
                    '9930':
                        begin
                            Validate("Location Code", 'LEV_ELIPS');
                            Validate("Shelf No.", 'LEV_ELIPS');
                            Modify;
                        end;
                    '9940':
                        begin
                            Validate("Location Code", 'LEV_ELIPS');
                            Validate("Shelf No.", 'LEV_ELIPS');
                            Modify;
                        end;


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
        TxtGTest: Text[4];
}

