Codeunit 50023 "Journal Post Successful"
{

    trigger OnRun()
    begin
    end;


    procedure PostedSuccessfully(VAR DocNo: Code[20]) Posted: Boolean
    var
        GLEntry: Record "G/L Entry";
    begin
        Posted := FALSE;
        GLEntry.RESET;
        GLEntry.SETRANGE(GLEntry."Document No.", DocNo);
        IF GLEntry.FIND('-')
        THEN
            Posted := TRUE;
    end;
}

