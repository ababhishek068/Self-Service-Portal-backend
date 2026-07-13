page 50265 "Deployment Confirmation Card"
{
    PageType = card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Deployment Request";
    Editable = false;
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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Requested Service M/W"; Rec."Requested Service M/W")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requested Service M/W field.';

                }
                field("Availlable Accomodation"; Rec."Availlable Accomodation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Availlable Accomodation field.';

                }
                field("Service Region"; Rec."Service Region")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Region field.';

                }
                field("Service Unit"; Rec."Service Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Unit field.';

                }
                field("Service Duties"; Rec."Service Duties")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Duties field.';

                }

                field("Requested Start Date"; Rec."Requested Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requested Start Date field.';

                }
                field("Project End Date"; Rec."Project End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Project End Date';
                    ToolTip = 'Specifies the value of the Project End Date field.';
                }
                field("Project Status"; Rec."Project Status")
                {
                    ApplicationArea = All;
                    Caption = 'Project Status';
                    ToolTip = 'Specifies the value of the Project Status field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posted By field.';
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field("Expected Date"; Rec."Expected Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Expected Date field.';
                }
                field("Arrival Date"; Rec."Arrival Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Arrival Date field.';
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
                ApplicationArea = basic;
                Image = Allocate;
                Caption = 'Confirmation Lines';
                RunObject = page "Deployment Confirmation Lines";
                RunPageLink = "Deployment No" = field(No);
                ToolTip = 'Executes the Confirmation Lines action.';
            }
            action(PostDeployment)
            {
                ApplicationArea = All;
                Caption = 'Confirm Allocation';
                Image = PostedPutAway;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Confirm Allocation action.';
                trigger OnAction();
                var
                    RegForm: Record "Registration Form";
                    DutiesAll: record "Deployment Lines";
                begin
                    Rec.TestField(Posted, false);
                    DutiesAll.reset;
                    DutiesAll.setrange("Deployment No", Rec.No);
                    DutiesAll.setrange("Academy Confirmed", true);
                    if not DutiesAll.find('-') then Error('You have not Confirmed S/M/W');

                    DutiesAll.reset;
                    DutiesAll.setrange("Deployment No", Rec.No);
                    DutiesAll.setrange("Academy Confirmed", false);
                    DutiesAll.setrange(Remarks, '');
                    if DutiesAll.find('-') then Error('Give remarks for the unconfirmed S/M/W');

                    if Confirm('Do you really want to Confirm the allocation', false) then begin
                        DutiesAll.reset;
                        DutiesAll.setrange("Deployment No", Rec.No);
                        if DutiesAll.find('-') then begin
                            repeat
                                if RegForm.get(DutiesAll."Serial No") then begin
                                    RegForm."Current Station" := Rec."Service Unit";
                                    RegForm.Status := RegForm.Status::Service;
                                    RegForm.modify;
                                end;
                            until DutiesAll.next = 0;
                        end;
                        Rec.Posted := true;
                        Rec."Posted By" := UserId;
                        Rec."Date Posted" := today;
                        Rec.modify;
                    end;
                end;
            }
        }
    }
}