Page 51259 "HR Employees Dependants"
{
    Caption = 'Employee Dependants';
    PageType = List;
    SourceTable = "HR Employee Kin";
    SourceTableView = where(Type = filter(Dependant));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(MemberID; Rec."Member ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Member ID field.';
                }
                field(SurName; Rec.SurName)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the SurName field.';
                }
                field(OtherNames; Rec."Other Names")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Other Names field.';
                }
                field(Relationship; Rec.Relationship)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Relationship field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field(DateOfBirth; Rec."Date Of Birth")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Of Birth field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field("Card No"; Rec."Card No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Card No field.';
                }
                field(Occupation; Rec.Occupation)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Occupation field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field(OfficeTelNo; Rec."Office Tel No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Office Tel No field.';
                }
                field(HomeTelNo; Rec."Home Tel No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Home Tel No field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(NextofKin)
            {
                Caption = '&Next of Kin';
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = const("Employee Relative"),
                                  "No." = field("Employee Code"),
                                  "Table Line No." = field("Line No.");
                    ToolTip = 'Executes the Co&mments action.';
                }
            }
        }
    }

}

