page 50592 "TNA Application Lines"
{
    PageType = list;
    SourceTable = "TNA Application List";
    UsageCategory = Lists;
    ApplicationArea = basic;
    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Proposed Intervention"; Rec."Proposed Intervention")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Training Name field.';
                }
                field("justification(Skill Gap)"; Rec."justification(Skill Gap)")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the justification(Skill Gap) field.';
                }
                field("Proposed Start Date"; Rec."Proposed Start Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Proposed Start Date field.';
                }
                field("Duration Units"; Rec."Duration Units")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Duration Units field.';
                }
                field("Proposed End Date"; Rec."Proposed End Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Proposed End Date field.';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Location field.';
                }

                field("Need Source"; Rec."Need Source")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Need Source field.';
                }
                field("Quarter Offered"; Rec."Quarter Offered")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Quarter Offered field.';
                }
                field(Trainer; Rec.Trainer)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Trainer field.';
                }
                field("Trainer Name"; Rec."Trainer Name")
                {
                    Editable = true;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Trainer Name field.';
                }

                field("Source of Funds"; Rec."Source of Funds")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Source of Funds field.';
                }
                field("Cost Of Training"; Rec."Cost Of Training")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Cost Of Training field.';
                }
                field("Daily Subsistence"; Rec."Daily Subsistence")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Daily Subsistence field.';
                }
                field("Transport Transfers"; Rec."Transport Transfers")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Transport Transfers field.';
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Total Cost field.';
                }
            }
        }
    }

    actions { }
    trigger OnAfterGetCurrRecord()
    begin
    end;
}

