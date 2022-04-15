codeunit 99990 "PWD test LALE"
{

    trigger OnRun()
    begin
        /*
        IntG1 := 10;
        IntG2 := 15;
        
        MESSAGE('%1',IntG1+(IntG2 - IntG1) DIV 2);
        
        RecGStandardText.GET('sc');
        MESSAGE('%1',RecGStandardText);
        RecGStandardText.NEXT;
        MESSAGE('%1',RecGStandardText);
        */

        Error(CstG007, '<N° Article>', '<N° Doc>');

    end;

    var
        CstG007: Label 'Attention pour l''article %1 l''écriture correspondant au document %2 n''a pas été entiérement facturée !\Traitement annulé !';
}

