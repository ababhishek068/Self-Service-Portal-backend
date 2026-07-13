Page 50017 "Auto Time Table List"
{
    CardPageID = "Auto Time Table";
    PageType = List;
    SourceTable = "Time Table Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
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
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(Campus; Rec.Campus)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus field.';
                }
                field(Day; Rec.Day)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Day field.';
                }
                field(Lecturer; Rec.Lecturer)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lecturer field.';
                }
                field(LecturerRoom; Rec."Lecturer Room")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lecturer Room field.';
                }
                field(MaxHoursContiniously; Rec."Max Hours Continiously")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Hours Continiously field.';
                }
                field(MaxHoursWeekly; Rec."Max Hours Weekly")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Hours Weekly field.';
                }
                field(MaxDaysPerWeek; Rec."Max Days Per Week")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Days Per Week field.';
                }
                field(MaxLecturerHoursDaily; Rec."Max Lecturer Hours Daily")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Lecturer Hours Daily field.';
                }
                field(MaxLecturerDaysPerWeek; Rec."Max Lecturer Days Per Week")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Lecturer Days Per Week field.';
                }
                field(MaxClassCapacity; Rec."Max Class Capacity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Class Capacity field.';
                }
                field(MaxClassWeekly; Rec."Max Class Weekly")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Class Weekly field.';
                }
                field(Released; Rec.Released)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Released field.';
                }
                field(ReleasedBy; Rec."Released By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Released By field.';
                }
                field(ReleasedOn; Rec."Released On")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Released On field.';
                }
                field(LastOpenedBy; Rec."Last Opened By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Opened By field.';
                }
                field(LastOpenedOn; Rec."Last Opened On")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Opened On field.';
                }
            }
        }
    }

    actions { }
}

