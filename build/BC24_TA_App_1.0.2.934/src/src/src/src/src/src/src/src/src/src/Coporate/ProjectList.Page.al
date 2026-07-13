page 50996 "Project List."
{
    Caption = 'Project List';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Prices & Discounts,WIP,Navigate,Job,Print/Send';
    RefreshOnActivate = true;
    SourceTable = Job;
    CardPageId = "Project Card1";
    Editable = false;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';


                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Description; Rec.Description)
                {
                    caption = 'Project Name';
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a short description of the job.';
                }
                field("Project Duration (Years)"; Rec."Project Duration (Years)")
                {

                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a short description of the job.';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    caption = 'Primary Target Beneficiary';
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the number of the customer who pays for the project.';


                }
                field("Bill-to Contact No."; Rec."Bill-to Contact No.")
                {
                    caption = 'Beneficiary Contact';
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the contact person at the customer''s billing address.';
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    caption = 'Beneficiary Name';
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the customer who pays for the job.';
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    caption = 'Beneficiary Address';
                    ApplicationArea = Jobs;
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the address of the customer to whom you will send the invoice.';
                }



                field("Source of Funds"; Rec."Source of Funds")
                {
                    caption = 'Funding Agency';
                    ApplicationArea = Jobs;
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the value of the Funding Agency field.';

                }

                field("Project Objective"; Rec."Project Objective")
                {
                    caption = 'Goal of the Project';
                    ApplicationArea = Jobs;
                    Importance = Additional;
                    ToolTip = 'Specifies the name of the contact person at the customer who pays for the job.';
                }





                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies when the job card was last modified.';
                }

            }

        }
    }
}

