Page 50938 "HR Posting Groups"
{
    PageType = ListPart;
    SourceTable = "HR Posting Groups";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(PostingGroup; Rec."Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting Group field.';
                }
                field(TrainingDebitAccount; Rec."Training Debit Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Training Debit Account field.';
                }
                field(TrainingCreditACType; Rec."Training Credit A/C Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Training Credit A/C Type field.';
                }
                field(TrainingCreditAccount; Rec."Training Credit Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Training Credit Account field.';
                }
                field(CompActDebitAccount; Rec."Comp. Act. Debit Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comp. Act. Debit Account field.';
                }
                field(CompActCreditACType; Rec."Comp. Act. Credit A/C Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comp. Act. Credit A/C Type field.';
                }
                field(CompActCreditAccount; Rec."Comp. Act. Credit Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comp. Act. Credit Account field.';
                }
            }
        }
    }

    actions { }
}

