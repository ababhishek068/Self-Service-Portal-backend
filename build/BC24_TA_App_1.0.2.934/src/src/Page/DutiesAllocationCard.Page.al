page 50267 "Duties Allocation Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Duties Allocation Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Service Region"; Rec."Service Region")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Region field.';

                }
                field("Service Unit"; Rec."Service Unit")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Service Unit field.';
                }
                field("Service Commander"; Rec."Service Commander")
                {
                    ApplicationArea = All;
                    Caption = 'Commanding Officer';
                    ToolTip = 'Specifies the value of the Commanding Officer field.';

                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date field.';

                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date field.';

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posted field.';

                }
            }
            part(AllocationLines; "Duties Allocation Line")
            {
                ApplicationArea = basic;
                Caption = 'Allocation Lines';
                Editable = true;
                SubPageLink = "Service Unit" = field("Service Unit"), "Allocation No" = field(No);
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(AllLines)
            {
                ApplicationArea = basic;
                Image = Allocate;
                Caption = 'Allocation Lines';
                RunObject = page "Duties Allocation Line";
                RunPageLink = "Service Unit" = field("Service Unit"), "Allocation No" = field(No);
                ToolTip = 'Executes the Allocation Lines action.';
            }
            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Post Duties';
                Image = PostedPutAway;
                Promoted = true;
                ToolTip = 'Executes the Post Duties action.';
                trigger OnAction();
                var
                    RegForm: Record "Registration Form";
                    DutiesAll: record "Duties Allocation Line";
                begin
                    Rec.TestField(Posted, false);
                    Rec.TestField("Service Unit");

                    if Confirm('Do you really want to post the Duties', false) then begin
                        DutiesAll.reset;
                        DutiesAll.setrange("Allocation No", Rec.No);
                        if DutiesAll.find('-') then begin
                            repeat
                                if RegForm.get(DutiesAll."Serial No") then begin
                                    RegForm."Current Station" := Rec."Service Unit";
                                    RegForm."Current Main Duty" := DutiesAll."Service Duty";
                                    RegForm.modify;
                                end;
                            until DutiesAll.next = 0;
                        end;
                        Rec.Posted := true;
                        Rec."Posted By" := UserId;
                        Rec."Posting Date" := today;
                        Rec.modify;
                    end;
                end;
            }
            action(Reopen)
            {
                ApplicationArea = All;
                Caption = 'Re-Open';
                Image = PostedPutAway;
                Promoted = true;
                ToolTip = 'Executes the Re-Open action.';
                trigger OnAction();
                var
                    RegForm: Record "Registration Form";
                    DutiesAll: record "Duties Allocation Line";
                begin
                    Rec.TestField(Posted, true);

                    if Confirm('Do you really want to Re-open the allocation', false) then begin

                        DutiesAll.reset;
                        DutiesAll.setrange("Allocation No", Rec.No);
                        if DutiesAll.find('-') then begin
                            repeat
                                if RegForm.get(DutiesAll."Serial No") then begin
                                    RegForm."Current Station" := '';
                                    RegForm."Current Sub Duty" := '';
                                    RegForm."Current Main Duty" := '';
                                    RegForm.modify;
                                end;
                            until DutiesAll.next = 0;
                        end;

                        Rec.Posted := false;
                        Rec."Posted By" := UserId;
                        Rec."Posting Date" := today;
                        Rec.modify;
                    end;
                end;
            }
        }
    }
}