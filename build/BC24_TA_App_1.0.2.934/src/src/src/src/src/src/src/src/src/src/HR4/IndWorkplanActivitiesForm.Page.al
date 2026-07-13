Page 51084 "Ind Workplan Activities Form"
{
    PageType = List;
    SourceTable = "Individual Target Activities";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Activity; Rec.Activity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Activity field.';
                }
                field("Resources Required"; Rec."Resources Required")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Resources Required field.';
                }
                field("Expected Results"; Rec."Expected Results")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Results field.';
                }
                field("Time Frame"; Rec."Time Frame")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Frame field.';
                }
                field("Performance Indicator"; Rec."Performance Indicator")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Performance Indicator field.';
                }
            }
        }
    }
}

