page 50095 "Programme Categories"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Programme Categories";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category field.';

                }
                field("Application Fee Code"; Rec."Application Fee Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application Fee Code field.';

                }
                field("Application Fee Amount"; Rec."Application Fee Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application Fee Amount field.';

                }

                field("Claim Per Unit"; Rec."Claim Per Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Claim Per Unit field.';

                }
                field("Claim Per Additional Unit"; Rec."Claim Per Additional Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Claim Per Additional Unit field.';

                }
                field("Maximum Students"; Rec."Maximum Students")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum Students field.';
                }
                field("Probation List Max. GPA"; Rec."Probation List Max. GPA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Probation List Max. GPA field.';
                }
                field("Dean List Min. GPA"; Rec."Dean List Min. GPA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dean List Min. GPA field.';
                }
                field("Dean List Min. Credit"; Rec."Dean List Min. Credit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dean List Min. Credit field.';
                }
                field("Admissions Letter Report ID"; Rec."Admissions Letter Report ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Admissions Letter Report ID field.';
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ProgMatrix)
            {
                ApplicationArea = All;
                Caption = 'Progression Matrix';
                RunObject = page "Progression Matrix";
                RunPageLink = Category = field(Code);
                ToolTip = 'Executes the Progression Matrix action.';
            }



        }
    }
}