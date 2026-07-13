pageextension 50049 "FA Card" extends "Fixed Asset Card"
{
    layout
    {
        modify("Responsible Employee")
        {
            Visible = false;
        }
        modify("FA Subclass Code")
        {
           trigger OnAfterValidate()
           var
           fasub: Record "FA Subclass";
           begin
            fasub.Reset();
            fasub.SetRange(fasub.Code,"FA Subclass Code");
            fasub.SetRange(fasub."FA Class Code","FA Class Code");
            if fasub.FindFirst() then begin
                "Residual Calculation %":=fasub."Residue(%)";
                Validate("Residual Calculation %");
            end;
           end; 

        }
        
      
        addafter("Responsible Employee")
        {
            field("Assigned Employee"; Rec."Assigned Employee")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Assigned Employee field.';
            }
        }
        addafter("No.")
        {
            field("Asset Tag"; Rec."Asset Tag")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Asset Tag field.';
            }
        }
        addafter(BookValue){
            field("Residual Value";"Residual Value"){
                ApplicationArea=basic;
            }
        }
        addafter(BookValue)
        {
            field("Residual Calculation %";"Residual Calculation %"){
                ApplicationArea=basic;
            }
        }
        addbefore(BookValue)
        {
            field("Purchase Amount";"Purchase Amount"){
                ApplicationArea=basic;
            }
        }
        addbefore(BookValue)
        {
            field("Salvage Value Calculated";"Salvage Value Calculated"){
                ApplicationArea=basic;
            }
        }
        addafter("Depreciation Book")
        {
            group(armodepr)
            {
                Caption='Amortization/Depreciation';
                field("Payment Voucher No";"Payment Voucher No")
            {
                ApplicationArea = basic;
                
            }         
        
                    field("Next Reconcilition Date";"Next Reconcilition Date")
            {
                ApplicationArea = basic;
            }
        
            field("Invoice Period";"Invoice Period")
            {
                ApplicationArea = basic;
            }
        
            field("Armotization/Depreciation Date";"Armotization/Depreciation Date")
            {
                ApplicationArea = basic;
            }
       
            field("Installment Amount";"Installment Amount")
            {
                ApplicationArea=basic;
            }
        
            field("Next Invoice Date";"Next Invoice Date"){
                ApplicationArea=basic;
            }
        
            field("Next Invoice Period Start";"Next Invoice Period Start"){
                ApplicationArea=basic;
            }
        
            field("Next Invoice Period End";"Next Invoice Period End"){
                ApplicationArea=basic;
            }
        
            field(Prepaid;Prepaid){
                ApplicationArea=basic;
            }
            }
        }
       
        addafter(General)
        {
            group(Additional)
            {
                Caption = 'Additional Details';
                field("Source of Funds"; Rec."Source of Funds")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Source of Funds field.';
                }
                field("Make/Model"; Rec."Make/Model")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Make/Model field.';
                }
                field("Installation Date"; Rec."Installation Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Installation Date field.';
                }
                field("PV Number"; Rec."PV Number")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the PV Number field.';
                }
                field("Original Location"; Rec."Original Location")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Original Location field.';
                }
                field("Replacement Date"; Rec."Replacement Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Replacement Date field.';
                }
                // field("Purchase Amount"; Rec."Purchase Amount")
                // {
                //     ApplicationArea = basic;
                //     ToolTip = 'Specifies the value of the Purchase Amount field.';
                // }
                field("Vendor No.1"; Rec."Vendor No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the number of the vendor from which you purchased this fixed asset.';
                }
                field("Asset Condition"; Rec."Asset Condition")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Asset Condition field.';
                }
            }
        }
        addafter(General)
        {
            group(categorizations)
            {
                Caption='Fixed asset categorization';
                field("Item Category Code";"Item Category Code"){
                    ApplicationArea=basic;
                }
                field("Category Name";"Category Name"){
                    ApplicationArea=basic;
                }
                field("Item Sub-Category";"Item Sub-Category"){
                    ApplicationArea=basic;
                }
                field("Sub-Category name";"Sub-Category name"){
                    ApplicationArea=basic;
                }
            }
        }
    }
  
    

    actions
    {
        // Add changes to page actions here
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
       faledger: record  "FA Ledger Entry";
       fasub: Record "FA Subclass";
        UserRec: record "User Setup";
    begin
        UserRec.Get(Database.UserId);
        UserRec.TestField("Can Create Asset");

    end;
}