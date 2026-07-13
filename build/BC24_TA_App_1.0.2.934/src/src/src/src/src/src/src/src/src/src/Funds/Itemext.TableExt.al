tableextension 50029 "Item_ext" extends Item
{
    fields
    {
        field(70134680; "Item G/L Budget Account"; Code[20])
        {
            TableRelation = "G/L Account"."No." where("Budget Controlled" = const(true));
        }
        field(70134681; "Additional Convertion Rate"; Decimal) { }

        field(50000;"Item Sub-Category";code[50]){
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
        field(50001; "Category Name";Text[50]){}
        field(50002;"Sub-Category name";Text[50]){}
        field(50003;"Item Coding";text[50]){}
        field(50004;"Part No";Code[50]){}
        field(50005;"Serial No";Code[50]){}
        field(50006;Model;code[50]){}
        field(50007;Brand;code[50]){}
    }
    var
    itemcat: record "Item Category";
    itemsub: Record "Item Subcategory";
}