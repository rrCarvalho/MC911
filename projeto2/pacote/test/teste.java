class a
{
	public static void main(String[] args)
	{{
		System.out.println(new b().m(10));
	}}
}

class b
{	
	int[] i;
	
	public int m(int ss)
	{
		int k;
		
		k = this.n(ss);
			
		return k;
	}
	
	public int n(int sz)
	{
		i = new int[sz];
		
		return i.length;
	}
}
