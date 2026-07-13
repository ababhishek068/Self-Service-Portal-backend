page 50509 "Case Suspects"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Case Suspect";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';

                }
                field("ID Number"; Rec."ID Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID Number field.';

                }
                field(Age; Rec.Age)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Age field.';

                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gender field.';

                }
                field(Occupation; Rec.Occupation)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Occupation field.';

                }
                field("Place of Work"; Rec."Place of Work")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Place of Work field.';

                }
                field(Region; Rec.Region)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Region field.';

                }
                field("Sub Region"; Rec."Sub Region")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sub Region field.';

                }
                field(Ward; Rec.Ward)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ward field.';

                }
                field(Village; Rec.Village)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Village field.';

                }
                field("Nearest Reference Institution"; Rec."Nearest Reference Institution")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nearest Reference Institution field.';

                }
                field("Place Residence"; Rec."Place Residence")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Place Residence field.';

                }
                field("Phone No"; Rec."Phone No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Phone No field.';

                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email field.';

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction()
                begin

                end;
            }
        }
    }
}