package app.ta;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.en.EnglishAnalyzer;
import org.apache.lucene.analysis.tokenattributes.CharTermAttribute;
import org.apache.lucene.analysis.util.CharArraySet;
import org.apache.lucene.util.Version;

public class DataTokenization {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
//		DocMatrix docMatrix = new DocMatrix();
//		docMatrix.initRawDocWithPrefix("hashtag");
//		System.out.println("Total documents:"+docMatrix.getTotalDocSize()+" Unique documents:"+docMatrix.getUniqueDocSize()+
//				" Ratio: "+docMatrix.getUniqueRatio());
//		docMatrix.preBuild("stopwords.txt");
		//docMatrix.buildTfIdfWeight();
		//docMatrix.writeDocToFile();
		//docMatrix.writeTokenToFile();
		//docMatrix.writeSparseMatrixWeightToFile();
		
		run("#apple");
		run("#google");
		run("#microsoft");
		run("#michigan");
		run("#cometlanding");
	}
	
	public static void run(String hashtag){
		DocMatrix docMatrix = new DocMatrix();
		docMatrix.initRawDocWithPrefix(hashtag);
		System.out.println("Total documents:"+docMatrix.getTotalDocSize()+" Unique documents:"+docMatrix.getUniqueDocSize()+
				" Ratio: "+docMatrix.getUniqueRatio());
		docMatrix.preBuild("stopwords.txt");
		docMatrix.buildTfIdfWeight();
		docMatrix.writeDocToFile();
		docMatrix.writeTokenToFile();
		docMatrix.writeSparseMatrixWeightToFile();
		docMatrix.writeSimpleFile();
	}
	

}



class Element{
	public int m_index = 0;
	public int m_count = 0;
	public double m_weight = 0;
	public Element(int index, int count){
		m_index = index;
		m_count = count;
	}
}

class RawDoc{
	private long m_docID;
	private int m_index=0;
	private String m_text;
	private String m_path;
	private List<Long> m_dupList = null;
	private Map<String,Element> m_tokenMap = null;
	private int m_totalTokenCounts=0;
	
	public int getDupSize(){
		if (m_dupList == null)
			return 0;
		return m_dupList.size();
	}
	

	public int getTotalTokenCounts(){
		return m_totalTokenCounts;
	}
	public RawDoc(long id, String text, String path) {
		m_docID = id;
		m_text = text;
		m_path = path;
	}

	public void addToken(String token, int index) {
		if (m_tokenMap == null)
			m_tokenMap = new HashMap<String, Element>();
		Element countObj = m_tokenMap.get(token);
		if (countObj == null)
			m_tokenMap.put(token, new Element(index, 1));
		else
			++countObj.m_count;
		++m_totalTokenCounts;
	}

	public String getText() {
		return m_text;
	}

	public long getDocID() {
		return m_docID;
	}
	
	public int getIndex(){
		return m_index;
	}
	
	public void setIndex(int index){
		m_index = index;
	}

	public void addToDup(long id) {
		if (m_dupList == null)
			m_dupList = new Vector<Long>();
		m_dupList.add(id);
	}

	public int getTokenCount(String tokenStr) {
		Element obj = this.m_tokenMap.get(tokenStr);
		if (obj == null)
			return 0;
		return obj.m_count;
	}

	public Map<String, Element> getTokenMap() {
		return m_tokenMap;
	}
	
	public StringBuffer getDupDocString() {
		StringBuffer buf = new StringBuffer();
		buf.append(this.m_docID);
		if (m_dupList != null) {
			for (int i = 0; i < this.m_dupList.size(); ++i) {
				buf.append("|" + m_dupList.get(i).longValue());
			}
		}
		return buf;
	}

}


class Token{
	private String m_text;
	private int m_index;
	private int m_count;
	private List<Element> m_docArray = new Vector<Element>();
	public Token(String text, int index){
		m_text = text;
		m_index = index;
		m_count = 1;
	}
	public void increaseCount(){
		++m_count;
	}
	
	public int getCount(){
		return m_count;
	}
	
	public List<Element> getDocArray(){
		return m_docArray;
	}
	
	public int getIndex(){
		return m_index;
	}
	
	public void AddDoc(Element element){
		m_docArray.add(element);
	}
	
	public String getText(){
		return m_text;
	}

}


class DocMatrix {

	private int m_totalDocSize = 0;
	private HashMap<String, RawDoc> m_strDocMap = new HashMap<String, RawDoc>();
	private List<RawDoc> m_docList = new Vector<RawDoc>();
	
	private Map<String, Token> m_tokenMap = new HashMap<String, Token>();
	private List<Token> m_tokenList = new Vector<Token>();
	private String m_prefix;

	public int getUniqueDocSize() {
		return m_docList.size();
	}

	public int getTotalDocSize() {
		return m_totalDocSize;
	}

	public double getUniqueRatio() {
		return (double) getUniqueDocSize() / (double) getTotalDocSize();
	}

	public void initRawDocWithPrefix(String prefix) {
		m_prefix = prefix;
		File dir = new File(".");
		File files[] = dir.listFiles();
		for (File f : files) {
			String fileName = f.getName();
			if (fileName.startsWith(prefix + "@") && fileName.endsWith(".csv")) {
				System.out.print("Processing file " + fileName + "...");
				getRawDoc(fileName);
				System.out.println("...Finished");
			}
		}
	}
	
	private void addToken(RawDoc doc, String tokenStr){
		
		int tokenIndex = 0;
		Token token = m_tokenMap.get(tokenStr);
		if(token == null){
			tokenIndex = m_tokenList.size();
			token = new Token(tokenStr, tokenIndex);
			m_tokenList.add(token);
			m_tokenMap.put(tokenStr, token);
		}
		else
			token.increaseCount();		
		doc.addToken(tokenStr, token.getIndex());
	}
	
	public void preBuild(String stopWordFile){
		CharArraySet stopset = getStopwords(stopWordFile);
		EnglishAnalyzer enAnalyzer = new EnglishAnalyzer(Version.LATEST, stopset);
		try {			
			System.out.println("Pre-processing");
			int count = 0;
			int size = m_strDocMap.size();
			for (RawDoc docObj:this.m_docList) {
				String text = docObj.getText();		
				TokenStream stream;
				stream = enAnalyzer.tokenStream(null, text);

				CharTermAttribute cattr = stream
						.addAttribute(CharTermAttribute.class);
				
				stream.reset();
				while (stream.incrementToken()) {
					String tokenStr = cattr.toString();
					addToken(docObj, tokenStr);
				}
				
				stream.end();
				stream.close();
				
				//add documents to token list
				for(Map.Entry<String, Element> tentry:docObj.getTokenMap().entrySet() ){
					Token t = m_tokenList.get(tentry.getValue().m_index);
					t.AddDoc(new Element(docObj.getIndex(),tentry.getValue().m_count));
				}
				
				
				++count;
				if(count % 10000 == 0){
					System.out.println("\t pre-processed "+count+"/"+size);
				}

			}

			System.out.println("Pre-processing finished, get " + m_tokenList.size()+" tokens.");
			
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void buildTfIdfWeight(){
		Token token;
		List<Element> docList;
		Element doc;
		int docSize;
		double weight;
		double tf,idf;
		RawDoc rawdoc;
		for(int i=0;i< m_tokenList.size(); ++i){
//			token = m_tokenList.get(i);
//			docList = token.getDocArray();
//			docSize = docList.size();
//			weight = Math.log10((double)token.getCount()/(double)docSize);
//			for(int j=0; j<docSize; ++j){
//				doc = docList.get(j);				
//				doc.m_weight = (double)doc.m_count * weight;
//			}
			token = m_tokenList.get(i);
			docList = token.getDocArray();
			docSize = docList.size();
			idf = Math.log((double)m_totalDocSize/(double)docSize);
			for(int j=0; j<docSize; ++j){				
				doc = docList.get(j);
				rawdoc = m_docList.get(doc.m_index);
				tf = (double)doc.m_count/(double)rawdoc.getTotalTokenCounts();
				doc.m_weight = tf*idf;
			}
			
		}
	}
	
	public void writeSimpleFile(){
		System.out.println("Begin write simple documents records to file");
		String filename = m_prefix+"_text.txt";
		StringBuffer buf = new StringBuffer();
		RawDoc doc;
		for(int i=0; i<m_docList.size(); ++i){
			doc = m_docList.get(i);
			buf.append(doc.getText()+"\n");
		}
		writeToFile(filename, buf);
		System.out.println("Finish");
	}
	
	public void writeDocToFile(){
		System.out.println("Begin write documents records to file");
		String filename = m_prefix+"_doc.csv";
		StringBuffer buf = new StringBuffer();
		buf.append("index,id,text,token_number, token,dup,dup_doc\n");
		RawDoc doc;
		for(int i=0; i<m_docList.size(); ++i){
			doc = m_docList.get(i);
			buf.append(doc.getIndex()+",");
			buf.append(doc.getDocID()+",");
			buf.append(doc.getText()+",");
			buf.append(doc.getTotalTokenCounts()+",");
			buf.append(getTokenListString(doc));
			buf.append(",");
			buf.append(doc.getDupSize()+",");
			buf.append(doc.getDupDocString());
			buf.append("\n");
		}
		writeToFile(filename, buf);
		System.out.println("Finish write documents records to file");
	}
	
	private void writeToFile(String filename, StringBuffer buf){
		 try {
			BufferedWriter bwr = new BufferedWriter(new FileWriter(filename));
			bwr.write(buf.toString());
			bwr.flush();
			bwr.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void writeTokenToFile(){
		System.out.println("Begin write token records to file");
		String filename = m_prefix+"_token.csv";
		Token token;
		StringBuffer buf = new StringBuffer();
		buf.append("index,token,size,doc\n");
		for(int i=0; i<m_tokenList.size(); ++i){
			token = m_tokenList.get(i);
			buf.append(token.getIndex()+",");
			buf.append(token.getText()+",");
			buf.append(token.getCount()+",");
			buf.append(getDocListString(token));
			buf.append("\n");
		}
		writeToFile(filename, buf);
		System.out.println("Finish write token records to file");
	}
	
	public void writeSparseMatrixWeightToFile(){
		System.out.println("Begin write sparse matrix to file");
		String filename = m_prefix+"_sparse.txt";
		Token token;
		Element element;
		double countsForValue = 0;
		StringBuffer buf = new StringBuffer();
		for(int i=0; i<m_tokenList.size(); ++i){
			token = m_tokenList.get(i);
			for(int j=0; j<token.getDocArray().size(); ++j){
				element=token.getDocArray().get(j); 
				buf.append(token.getIndex()+" "+ element.m_index+" "+element.m_weight+"\n");
				++countsForValue;
			}
		}
		writeToFile(filename, buf);
		double totalElementSize = (double)this.getUniqueDocSize()*(double)this.m_tokenList.size();
		System.out.println("Finish write sparse matrix to file:" +filename);
		double density = countsForValue/totalElementSize;
		 System.out.println("Density is:"+density);
	}
	
	private StringBuffer getTokenListString(RawDoc doc){
		StringBuffer buf = null;
		Token token;
		Element element;
		for(Map.Entry<String, Element> entry: doc.getTokenMap().entrySet()){
			element = entry.getValue();
			token = m_tokenList.get(element.m_index);
			if(buf != null){				
				buf.append("|");
			}
			else{
				buf = new StringBuffer();				
			}
			buf.append(token.getText()+":"+element.m_count+"/"+token.getCount());
		}
		return buf;
	}
	
	private StringBuffer getDocListString(Token token){
		StringBuffer buf = null;
		List<Element> docList = token.getDocArray();
		for(int i=0; i<docList.size(); ++i){
			Element element = docList.get(i);
			if(buf != null){
				buf.append("|");
			}
			else
				buf = new StringBuffer();
			buf.append(element.m_index+":"+element.m_count);
		}
		return buf;
	}

	private void getRawDoc(String strPath) {
		try {
			Path path = Paths.get(strPath);
			Charset charset = Charset.forName("ISO-8859-1");
			List<String> lines = Files.readAllLines(path, charset);
			System.out.print((lines.size() - 1) + " records...");
			int count = 0;
			for (String line : lines) {
				if (count == 0) // jump header
				{
					++count;
					continue;
				}
				String[] itemArray = line.split(",");
				if (itemArray.length < 5) {
					System.out.print("end at line " + count + ".");
					break;
				}
				String text = itemArray[4].toLowerCase()
						.replaceAll("_+|\\d+", " ").trim();				

				RawDoc rawRes = m_strDocMap.get(text);
				++m_totalDocSize;
				if (rawRes != null)
					rawRes.addToDup(Long.parseLong(itemArray[0]));
				else {
					RawDoc rawDoc = new RawDoc(Long.parseLong(itemArray[0]), text,
							strPath);
					rawDoc.setIndex(m_docList.size());
					m_docList.add(rawDoc);
					m_strDocMap.put(rawDoc.getText(), rawDoc);
				}
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("Read file " + strPath + " failed");
		}
	}
	
	private static CharArraySet getStopwords(String filepath) {
		try {
			File fp = new File(filepath);
			Vector<String> stopVector = new Vector<String>();
			FileReader reader = new FileReader(fp);
			BufferedReader br = new BufferedReader(reader);
			String s;
			while ((s = br.readLine()) != null) {
				s = s.trim();
				s = s.toLowerCase();
				String ts = s;
				stopVector.add(ts);
			}
			reader.close();
			CharArraySet stopSet = new CharArraySet(Version.LATEST, stopVector,	true);
			return stopSet;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

}


