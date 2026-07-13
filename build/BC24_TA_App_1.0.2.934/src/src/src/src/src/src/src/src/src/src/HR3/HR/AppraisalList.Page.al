page 51122 "Appraisal List"
{
    PageType = List;
    SourceTable = "HR Appraisal Card1";
    CardPageId = "Appraisal Card";
    Editable = false;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Appraisal Code field.';
                }
                field("Staff No"; Rec."Staff No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Staff No field.';
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Staff Name field.';
                }

                field("Appraisal Period"; Rec."Appraisal Period")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Appraisal Period field.';
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Appraisal Type field.';
                }

            }
        }
    }


}

