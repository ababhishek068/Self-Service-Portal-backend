Page 50803 "HMS Setup Lab Pack Test SF"
{
    PageType = List;
    SourceTable = "HMS Setup Lab Package Test";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Test; Rec.Test)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Test field.';
                }
                field(TestName; Rec."Test Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Test Name field.';
                }
            }
        }
    }

    actions { }
}

