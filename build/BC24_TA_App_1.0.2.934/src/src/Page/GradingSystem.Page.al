Page 50070 "Grading System"
{
    PageType = List;
    SourceTable = "Grading System Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grade field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Upto; Rec."Up to")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Up to field.';
                }
                field("GPA Points"; Rec."GPA Points")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the GPA Points field.';
                }
                field(Range; Rec.Range)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Range field.';
                }
                field(Failed; Rec.Failed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Failed field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(RepeatRemarks; Rec."Repeat Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Repeat Remarks field.';
                }
            }
        }
    }

    actions { }
}

