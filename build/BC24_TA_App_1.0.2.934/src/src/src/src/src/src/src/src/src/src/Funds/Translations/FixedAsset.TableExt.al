tableextension 50024 "Fixed Asset" extends "Fixed Asset"
{
    fields
    {
        field(50000; "Assigned Employee"; Code[20])
        {
            
            Editable=false;
             TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
            begin
              emplist.SetRange(emplist."No.","Assigned Employee");
              if emplist.FindFirst() then begin
                   "Employee Name":=emplist."First Name"+ ' '+emplist."Middle Name"+' '+emplist."Last Name";

              end

            end;
        }
        field(50001; "Asset Tag"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable=false;
        }
        field(50;"Old Tag No"; Code[50]){}
        field(50002; "Source of Funds"; Code[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Make/Model"; Code[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Installation Date"; date)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "PV Number"; Code[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Original Location"; Code[80])
        {
            DataClassification = ToBeClassified;
            
        }
        field(50007; "Replacement Date"; date)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Asset Condition"; Code[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Purchase Amount"; Decimal)
        {
                       
            CalcFormula = sum("FA Ledger Entry".Amount where("FA No." = field("No."), "FA Posting Type"=const("Acquisition Cost"),Amount=filter(>0)));
            Caption = 'Purchase Cost';
            Editable = false;
            FieldClass = FlowField;
            trigger OnValidate()
            begin
                Validate("Residual Calculation %");
            end;

        }
        field(50010; "Employee Name";Text[50])
        {

        }
        field(50011;"Residual Value";Decimal){
            editable=false;
            Caption='Residue Value(Projected)';
        }
        field(50012;"Residual Calculation %";decimal){
            Editable=false;
            trigger OnValidate()
            begin
                CalcFields("Purchase Amount");
                if ("Purchase Amount"<>0) and ("Residual Calculation %"<>0) then begin
                     "Residual Value":=("Residual Calculation %"/100)*"Purchase Amount";

                end;
               

            end;

        }
         field(50013; "Salvage Value Calculated"; Decimal)
        {
                       
            CalcFormula = sum("FA Ledger Entry".Amount where("FA No." = field("No."), "FA Posting Type"=const("Salvage Value"),Amount=filter(>0)));
            Caption = 'Salvage Value(Calculated)';
            Editable = false;
            FieldClass = FlowField;

        }


        field(50014; "Next Reconcilition Date"; Date)
        {
            Caption = 'Next Reconcilition Date';
            DataClassification = CustomerContent;
             trigger OnValidate()
                var
                begin
                    if Rec."Next Reconcilition Date">Today then begin

                    end else if Rec."Next Reconcilition Date"<=Today then
                    Error('Date must be greater than today');


                end;
        }
        field(50015; "Payment Voucher No"; Code[20])
        {
            Caption = 'Payment Voucher No';
            DataClassification = CustomerContent;
        }
        field(50016; "Installment Amount"; Decimal)
        {
            Caption = 'Installment Amount per Reconciliation';
            DataClassification = CustomerContent;
        }


        field(50017; "Invoice Period"; Enum "Service Contract Header Invoice Period")
        {
            Caption = 'Invoice Period';
            trigger OnValidate()
            begin
                TestField("Armotization/Depreciation Date");
                case "Invoice Period" of
                    "Invoice Period"::Month:
                        "Next Invoice Date" := CalcDate('<1M>', "Armotization/Depreciation Date");
                    "Invoice Period"::"Two Months":
                        "Next Invoice Date" := CalcDate('<2M>', "Armotization/Depreciation Date");
                    "Invoice Period"::Quarter:
                        "Next Invoice Date" := CalcDate('<3M>', "Armotization/Depreciation Date");
                    "Invoice Period"::"Half Year":
                        "Next Invoice Date" := CalcDate('<6M>', "Armotization/Depreciation Date");
                    "Invoice Period"::Year:
                        "Next Invoice Date" := CalcDate('<12M>', "Armotization/Depreciation Date");
                    "Invoice Period"::None:
                        if Prepaid then
                            "Next Invoice Date" := 0D;
                end;
                if not Prepaid and ("Next Invoice Date" <> 0D) then
                    "Next Invoice Date" := CalcDate('<CM>', "Next Invoice Date");

                // if ("Last Invoice Date" <> 0D) and ("Last Invoice Date" <> xRec."Last Invoice Date") then
                //     if Prepaid then
                //         Validate("Last Invoice Period End", "Next Invoice Period End")
                //     else
                //         Validate("Last Invoice Period End", "Last Invoice Date");

                Validate("Next Invoice Date");
            end;
            

        
        }
        field(50018; "Last Invoice Date"; Date)
        {
            Caption = 'Last Invoice Date';
            Editable = false;

            
        }
        field(50019; "Next Invoice Date"; Date)
        {
            Caption = 'Next Invoice Date';
            Editable = false;

        }
        
        field(50020; "Amount per Period"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Amount per Period';
            Editable = false;
        }

        field(50021; "Next Invoice Period Start"; Date)
        {
            Caption = 'Next Invoice Period Start';
            Editable = false;
        }
        field(50022; "Next Invoice Period End"; Date)
        {
            Caption = 'Next Invoice Period End';
            Editable = false;
        }
        field(50023; Prepaid; Boolean)
        {
            Caption = 'Prepaid';
        }
        field(50024;"Armotization/Depreciation Date";Date){
            Editable=true;
            Caption='Posting Date';
            
        }
        field(50025;"Item Sub-Category";code[50]){
            TableRelation= "Item Subcategory"."Item Sub Category" where("Item Category"=field("Item Category Code"));
            trigger OnValidate()
            begin
                TestField("Item Category Code");
                Clear("Category Name");
                Clear("Sub-Category name");
                Clear("Item Coding");
                itemcat.Reset();
                itemcat.SetRange(itemcat.Code,"Item Category Code");
                if itemcat.Find('-') then begin

                    "Category Name":=itemcat.Description;
                    itemsub.Reset();
                    itemsub.SetRange(itemsub."Item Category","Item Category Code");
                    itemsub.SetRange(itemsub."Item Sub Category","Item Sub-Category");
                    if itemsub.FindFirst() then begin
                        "Sub-Category name":=itemsub."Sub Category Name";
                        "Item Coding":="Item Category Code"+'/'+"Item Sub-Category";
                    end;
                end;
            end;
        }
        field(50026; "Category Name";Text[50]){}
        field(50027;"Sub-Category name";Text[50]){}
        field(50028;"Item Coding";text[50]){}
        field(50029;"Item Category Code";code[20]){
            TableRelation="Item Category".Code;
        }
    
    }
    var
    emplist: Record "HR-Employee";
    tempdate: Date;
    itemcat:Record "Item Category";
    itemsub:Record "Item Subcategory";
}