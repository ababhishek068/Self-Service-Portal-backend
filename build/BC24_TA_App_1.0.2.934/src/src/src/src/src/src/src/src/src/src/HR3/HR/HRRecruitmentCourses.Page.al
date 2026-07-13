page 51036 "HR Recruitment Courses"
{
    PageType = list;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "HR Recruitment Courses";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Course Code"; Rec."Course Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Course Code field.';

                }
                field("Course Description"; Rec."Course Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Course Description field.';

                }
            }
        }
    }


}