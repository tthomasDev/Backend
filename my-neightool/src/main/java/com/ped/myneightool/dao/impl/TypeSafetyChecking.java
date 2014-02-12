package com.ped.myneightool.dao.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class TypeSafetyChecking {
	
	public TypeSafetyChecking(){
	
	}
	
	public static <T> List<T> castList(Class<? extends T> clazz, Collection<?> c) {
	    List<T> r = new ArrayList<T>(c.size());
	    for(Object o: c)
	      r.add(clazz.cast(o));
	    return r;
	}

}
