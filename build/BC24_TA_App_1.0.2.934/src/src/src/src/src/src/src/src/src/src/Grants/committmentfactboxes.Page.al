Page 51162 "committment factboxes"
{
    PageType = ListPart;
    SourceTable = Committment;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field(GLAccountNo; Rec."G/L Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the G/L Account No. field.';
                }
                field(BudgettedMount; BudgettedMount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Budgetted Amount';
                    ToolTip = 'Specifies the value of the Budgetted Amount field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Commited Amount';
                    ToolTip = 'Specifies the value of the Commited Amount field.';
                }
                field(Actual; Actual)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Actual field.';
                }
                field(Balance; BudgettedMount - (TotalCommitment + Actual))
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the BudgettedMount - (TotalCommitment + Actual) field.';
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(ShortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(ShortcutDimension4Code; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field("Total Commitement"; TotalCommitment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the TotalCommitment field.';
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        Actual := 0;
        BudgettedMount := 0;
        TotalCommitment := 0;


        dims[1] := '';
        dims[2] := '';
        dims[3] := '';
        dims[4] := '';

        BCSetup.Reset;
        BCSetup.Get();
        //GLBudgetEntry.RESET;

        //Purchase header-----
        purchheader.Reset;
        purchheader.SetRange(purchheader."No.", Rec."Document No.");
        if purchheader.Find('-') then begin
            mDimSetEntry := purchheader."Dimension Set ID";
        end;

        x := 1;
        /*
        dimSetEntry.RESET;
        dimSetEntry.SETRANGE(dimSetEntry."Dimension Set ID","Dimension Set ID");
        dimSetEntry.SETRANGE(dimSetEntry."Dimension Code");
        IF dimSetEntry.FIND('-') THEN
        BEGIN REPEAT
         IF dimSetEntry."Dimension Code"='DEPARTMENT' THEN
          dims[3]:=dimSetEntry."Dimension Value Code";
         IF dimSetEntry."Dimension Code"='Region' THEN
          dims[4]:=dimSetEntry."Dimension Value Code";
        
        UNTIL dimSetEntry.NEXT=0;
        END;
        */
        glBEntry.Reset;
        glBEntry.SetRange(glBEntry."Budget Name", BCSetup."Current Budget Code");
        glBEntry.SetFilter(glBEntry.Date, '%1..%2', BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
        glBEntry.SetRange(glBEntry."G/L Account No.", Rec."G/L Account No.");
        glBEntry.SetRange(glBEntry."Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        glBEntry.SetRange(glBEntry."Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
        glBEntry.SetRange(glBEntry."Budget Dimension 1 Code", dims[3]);
        glBEntry.SetRange(glBEntry."Budget Dimension 2 Code", dims[4]);
        //glBEntry.SETRANGE("Dimension Set ID","Dimension Set ID");
        if glBEntry.Find('-') then begin
            repeat
                BudgettedMount := BudgettedMount + glBEntry.Amount;
            until glBEntry.Next = 0;
        end;
        //Actual
        glEntry.Reset;
        glEntry.SetRange(glEntry."G/L Account No.", Rec."G/L Account No.");
        glEntry.SetRange(glEntry."Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        glEntry.SetRange(glEntry."Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
        glEntry.SetRange(glEntry."Global Dimension 1 Code", dims[3]);
        glEntry.SetRange(glEntry."Global Dimension 2 Code", dims[4]);
        glEntry.SetFilter(glEntry."Posting Date", '%1..%2', BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
        //glEntry.SETRANGE("Dimension Set ID","Dimension Set ID");

        if glEntry.Find('-') then begin
            repeat
                Actual := Actual + glEntry.Amount;
            until glEntry.Next = 0;
        end;

        //actual
        commitment.Reset;
        commitment.SetRange(commitment."G/L Account No.", Rec."G/L Account No.");
        commitment.SetRange(commitment.Budget, BCSetup."Current Budget Code");
        commitment.SetRange(commitment."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        commitment.SetRange(commitment."Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
        //commitment.SETRANGE(commitment."Shortcut Dimension 3 Code","Shortcut Dimension 3 Code");
        //commitment.SETRANGE(commitment."Shortcut Dimension 4 Code","Shortcut Dimension 4 Code");
        commitment.SetFilter(commitment."Posting Date", '%1..%2', BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
        //commitment.SetRange(commitment."Dimension Set ID","Dimension Set ID");
        if commitment.Find('-') then
            repeat
                TotalCommitment := TotalCommitment + commitment.Amount;
            until commitment.Next = 0;

    end;

    var
        Actual: Decimal;
        glEntry: Record "G/L Entry";
        BudgettedMount: Decimal;
        glBEntry: Record "G/L Budget Entry";
        dims: array[5] of Code[50];
        purchheader: Record "Purchase Header";
        x: Integer;
        mDimSetEntry: Integer;
        TotalCommitment: Decimal;
        commitment: Record Committment;
        BCSetup: Record "Budgetary Control Setup";
}

