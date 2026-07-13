codeunit 50035 "Workplan-Indent"
{

    trigger OnRun()
    begin
        IF NOT
           CONFIRM(
             Text000 +
             Text001 +
             Text002 +
             Text003, TRUE)
        THEN
            EXIT;

        Indent;
    end;

    var
        Text000: Label 'This function updates the indentation of all the Workplan Items in the Workplan card. ';
        Text001: Label 'All accounts between a Begin-Total and the matching End-Total are indented one level. ';
        Text002: Label 'The Totaling for each End-total is also updated.';
        Text003: Label '\\Do you want to indent the Workplan List?';
        Text004: Label 'Indenting the Workplan#1##########';
        Text005: Label 'End-Total %1 is missing a matching Begin-Total.';
        GLAcc: Record "Workplan Activities";
        Window: Dialog;
        AccNo: array[10] of Code[20];
        i: Integer;

    procedure Indent()
    begin
        Window.OPEN(Text004);

        IF GLAcc.FIND('-') THEN
            REPEAT
                Window.UPDATE(1, GLAcc."Activity Code");

                IF GLAcc."Account Type" = GLAcc."Account Type"::"End-Total" THEN BEGIN
                    IF i < 1 THEN
                        ERROR(
                          Text005,
                          GLAcc."Activity Code");
                    GLAcc.Totalling := AccNo[i] + '..' + GLAcc."Activity Code";
                    i := i - 1;
                END;

                GLAcc.Indentation := i;
                GLAcc.MODIFY;

                IF GLAcc."Account Type" = GLAcc."Account Type"::"Begin-Total" THEN BEGIN
                    i := i + 1;
                    AccNo[i] := GLAcc."Activity Code";
                END;
            UNTIL GLAcc.NEXT = 0;

        Window.CLOSE;
    end;
}

