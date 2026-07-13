page 50442 "Service Duties"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Service Duties";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Sub Duties';
                Image = OutlookSyncSubFields;
                RunObject = page "Service Sub Duties";
                RunPageLink = "Main Duty" = field(Code);
                ToolTip = 'Executes the Sub Duties action.';
                trigger OnAction();
                begin

                end;
            }
        }
    }
}