Page 50305 "Lecturer Units Details"
{
    PageType = List;
    SourceTable = "Lecturers Units";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Programme; Rec.Programme)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage field.';
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(CampusCode; Rec."Campus Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Code field.';
                }
                field(ModeOfStudy; Rec."Mode Of Study")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mode Of Study field.';
                }
                field("Unit Department"; Rec."Unit Department")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Department field.';
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Class field.';
                }
                field(NoOfHours; Rec."No. Of Hours")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Of Hours field.';
                }
                field(NoOfHoursContracted; Rec."No. Of Hours Contracted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Of Hours Contracted field.';
                }
                field(AvailableFrom; Rec."Available From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Available From field.';
                }
                field(AvailableTo; Rec."Available To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Available To field.';
                }
                field(Claimed; Rec.Claimed)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Claimed field.';
                }

            }
        }
    }

    actions { }
}

